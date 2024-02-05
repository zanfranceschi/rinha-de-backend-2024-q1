package org.acme;

import java.time.LocalDateTime;

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
    public Response debitar(@PathParam("id") Integer id, Transacao t) {
        if(!existeCliente(id)) {
            throw new WebApplicationException(404);
        }
        if(!t.ehValida()) {
            throw new WebApplicationException(422);
        }
        Integer limite = 1000;
        Integer saldo = 0;
        LimiteSaldo limiteSaldo = new LimiteSaldo(limite, saldo);
        return Response.ok().entity(limiteSaldo).build();
    }

    @GET
    @Path("/{id}/extrato")
    @Produces(MediaType.APPLICATION_JSON)
    public Response extrato(@PathParam("id") Integer id) {
        if(!existeCliente(id)) {
            throw new WebApplicationException(404);
        }
        Extrato extrato = new Extrato();
        extrato.saldo.data_extrato = LocalDateTime.now();
        return Response.ok().entity(extrato).build();
    }

    private boolean existeCliente(Integer id) {
        return id >= 1 && id <= 5;
    }
}
