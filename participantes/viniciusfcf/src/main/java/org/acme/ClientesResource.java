package org.acme;

import java.time.LocalDateTime;

import jakarta.persistence.LockModeType;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/clientes")
public class ClientesResource {

    @POST
    @Path("/{id}/transacoes")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public Response debitarCreditar(@PathParam("id") Integer id, Transacao t) {
        if (!existeCliente(id)) {
            throw new WebApplicationException(404);
        }
        if (!t.ehValida()) {
            throw new WebApplicationException(422);
        }
        Cliente cliente = Cliente.findById(id);
        t.cliente_id = id;
        //TODO testar depois um find com lock e increment direto no java...
        if (t.tipo.equals('c')) {
            SaldoCliente.update("saldo = saldo + ?1 where id = ?2", t.valor, id);
        } else {
            try {
                SaldoCliente.update("saldo = saldo - ?1 where id = ?2", t.valor, id);
            } catch (Exception e) {
                // aqui pode ser um saldocheck =]
                throw new WebApplicationException(422);
            }
        }

        LimiteSaldo limiteSaldo = Cliente.find("select saldo from SaldoCliente where id = ?1", id).project(LimiteSaldo.class)
                .singleResult();

        t.realizada_em = LocalDateTime.now();

        t.persist();
        limiteSaldo.limite = cliente.limite;
        return Response.ok().entity(limiteSaldo).build();
    }

    @GET
    @Path("/{id}/extrato")
    @Produces(MediaType.APPLICATION_JSON)
    public Response extrato(@PathParam("id") Integer id) {
        if (!existeCliente(id)) {
            throw new WebApplicationException(404);
        }
        Extrato extrato = new Extrato();
        Cliente cliente = Cliente.findById(id);
        extrato.saldo.data_extrato = LocalDateTime.now();
        SaldoCliente saldoCliente = SaldoCliente.findById(id);
        extrato.saldo.total = saldoCliente.saldo;
        extrato.saldo.limite = cliente.limite;
        extrato.ultimas_transacoes = Transacao.find("cliente_id = ?1 order by id desc", id).page(0, 10).list();
        return Response.ok().entity(extrato).build();
    }

    private boolean existeCliente(int id) {
        return id > 0 && id < 6;
        // return Cliente.findById(id) != null;
    }
}
