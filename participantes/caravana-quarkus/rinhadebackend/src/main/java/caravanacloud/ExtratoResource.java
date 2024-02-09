package caravanacloud;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import io.quarkus.logging.Log;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.WebApplicationException;

@Path("/clientes/{id}/extrato")
public class ExtratoResource {

    @Inject
    DataSource ds;

    //curl -v -X GET http://localhost:9990/clientes/1/extrato
    @GET
    public Map<String, Object> getExtrato(
        @PathParam("id") Integer id
    ){
        var saldo = getSaldo(id);
        var txs = getTransacoes(id);
        var result = Map.of(
            "saldo", saldo,
            "ultimas_transacoes", txs
        );
        return result;
    }

    static final String SQL_CLIENTE = """
        SELECT * FROM clientes WHERE id = ?
    """;

    static final String SQL_TRANSACOES = """
        SELECT * FROM transacoes 
        WHERE cliente_id = ?
        ORDER BY realizada_em DESC
        LIMIT 10
    """;

    private List<Map> getTransacoes(Integer id) {
        try(var conn = ds.getConnection();
            var stmt = conn.prepareStatement(SQL_TRANSACOES)){
                stmt.setInt(1, id);
                var rs = stmt.executeQuery();
                var result = new ArrayList<Map>(); //TODO: set initial capacity?
                while (rs.next()) {
                    var t = Map.of(
                        "valor", rs.getInt("valor"),
                        "tipo", rs.getString("tipo"),
                        "descricao", rs.getString("descricao"),
                        "realizada_em", rs.getTimestamp("realizada_em")
                    );
                    result.add(t);
                }
                return result;
            }catch(SQLException e){
                e.printStackTrace();
                Log.debugf("Erro ao acessar o extrato", e);
                throw new WebApplicationException("Erro ao acessar o banco de dados", 500);
            }
    }

    static final DateTimeFormatter fmt = DateTimeFormatter
        .ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
        .withZone(ZoneId.of("UTC"));

    private Map getSaldo(Integer id) {
        try(var conn = ds.getConnection();
        var stmt = conn.prepareStatement(SQL_CLIENTE)){
            stmt.setInt(1, id);
            var rs = stmt.executeQuery();
            if (rs.next()) {
                var result = Map.of(
                    "total", rs.getInt("saldo"),
                    "data_extrato", fmt.format(LocalDateTime.now()),   //TODO? rs.getTimestamp("ultima_atualizacao"),
                    "limite", rs.getInt("limite")
                );
                return result;
            }else{
                Log.debug("Cliente nao encontrado");
                throw new WebApplicationException("Cliente nao encontrado", 404);
            }
        }catch(SQLException e){
            e.printStackTrace();
            Log.debugf("Erro ao acessar o saldo", e);
            throw new WebApplicationException("Erro ao acessar o banco de dados", 500);
        }
    }
}
