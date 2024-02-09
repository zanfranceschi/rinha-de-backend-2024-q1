package caravanacloud;

import java.util.Map;

import javax.sql.DataSource;

import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/_hc")
public class HealthCheckResource {
    private static final int TIMEOUT = 5;
    
    @Inject
    DataSource ds;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Map<String,String> healthCheck() {
        try(var conn = ds.getConnection()){
            var result = ""+conn.isValid(TIMEOUT);
            return Map.of("healthy", result);
        } catch (Exception e) {
            return Map.of("healthy","false");
        }
    }
    
}
