package caravanacloud;

import java.sql.SQLException;
import java.util.Map;

import javax.sql.DataSource;

import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.MediaType;

@Path("/clientes/{id}/transacoes")
public class TransacoesResource {
    @Inject
    DataSource ds;

    // curl -v -X POST -H "Content-Type: application/json" -d '{"valor":60000, "tipo": "d", "descricao": "teste"}' http://localhost:9990/clientes/1/transacoes
    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Transactional
    public void postTransacao(
        @PathParam("id") Integer id,
        Map<String, Object> t
    ){
        Log.tracef("Transacao recebida: %s %s ", id, t);
        var valor = (Integer) t.get("valor");
        var tipo = (String) t.get("tipo");
        var descricao = (String) t.get("descricao");

        var query = "{call proc_transacao(?, ?, ?, ?)}";

        try(var conn = ds.getConnection()){
            var stmt = conn.prepareCall(query); //TODO cache statement?
            stmt.setInt(1, id);
            stmt.setInt(2, valor);
            stmt.setString(3, tipo);
            stmt.setString(4, descricao);
            stmt.execute();
            stmt.close();
        } catch (SQLException e){
            Log.debug("Erro SQL ao processar a transacao", e);
            var msg = e.getMessage();
            if (msg.contains("LIMITE_INDISPONIVEL")){
                throw new WebApplicationException("Limite indisponivel", 422);
            }
            if (msg.contains("fk_clientes_transacoes_id")){
                throw new WebApplicationException("Cliente inexistente", 404);
            }
            e.printStackTrace();
            throw new WebApplicationException("Erro SQL ao processar a transacao", 500);
        } 
        catch (Exception e) {
            e.printStackTrace();
            Log.debug("Erro ao processar a transacao", e);
            throw new WebApplicationException("Erro ao processar a transacao", 500);
        }
        Log.debugf("Transacao processada: %s %s ", id, t);
    }
    
}
