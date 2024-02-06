package org.acme;

import java.time.LocalDateTime;

import jakarta.persistence.LockModeType;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/clientes")
public class ClientesResource {

    @POST
    @Path("/{id}/transacoes")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response debitarCreditar(@PathParam("id") Integer id, TransacaoEntrada te,
            @QueryParam("sleep1") boolean sleep1) throws InterruptedException {
        if (!existeCliente(id)) {
            return Response.status(404).build();
        }
        if (!te.ehValida()) {
            return Response.status(422).build();
        }
        te.cliente_id = id;

        Transacao t = Transacao.of(te);
        SaldoCliente saldoCliente = SaldoCliente.findById(id, LockModeType.PESSIMISTIC_WRITE);
        // TODO testar depois um find com lock e increment direto no java...
        int valor = Integer.parseInt(te.valor);
        if (te.tipo.equals("c")) {
            saldoCliente.saldo += valor;
        } else {
            if (saldoCliente.saldo - valor < -saldoCliente.limite) {
                return Response.status(422).build();
            }
            saldoCliente.saldo -= valor;
        }
        saldoCliente.persist();
        t.limite = saldoCliente.limite;
        t.saldo = saldoCliente.saldo;
        t.persist();
        LimiteSaldo limiteSaldo = new LimiteSaldo(saldoCliente.saldo, saldoCliente.limite);
        if (sleep1) {
            Thread.sleep(10000);
        }
        return Response.ok().entity(limiteSaldo).build();
    }

    @GET
    @Path("/{id}/extrato")
    @Produces(MediaType.APPLICATION_JSON)
    public Response extrato(@PathParam("id") Integer id,
    @QueryParam("sleep1") boolean sleep1) throws InterruptedException {
        if (!existeCliente(id)) {
            return Response.status(404).build();
        }
        Extrato extrato = new Extrato();
        extrato.saldo.data_extrato = LocalDateTime.now();
        extrato.ultimas_transacoes = Transacao.find("cliente_id = ?1 order by id desc", id).page(0, 10).list();
        if (extrato.ultimas_transacoes.size() > 0) {
            Transacao ultimaTransacao = extrato.ultimas_transacoes.get(0);
            extrato.saldo.total = ultimaTransacao.saldo;
            extrato.saldo.limite = ultimaTransacao.limite;
        } else {
            SaldoCliente saldoCliente = SaldoCliente.findById(id);
            extrato.saldo.total = saldoCliente.saldo;
            extrato.saldo.limite = saldoCliente.limite;
        }
        if (sleep1) {
            Thread.sleep(10000);
        }
        return Response.ok().entity(extrato).build();
    }

    private boolean existeCliente(int id) {
        return id > 0 && id < 6;
        // return Cliente.findById(id) != null;
    }
}
