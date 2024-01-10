import scala.concurrent.duration._

import scala.util.Random

import io.gatling.core.Predef._
import io.gatling.http.Predef._


class RinhaBackendDebitosCreditosSimulation
  extends Simulation {

  def randomClienteId() = Random.between(1, 5 + 1)
  def randomValorDebito() = Random.between(-10000, 0)
  def randomValorCredito() = Random.between(1, 10000 + 1)

  val httpProtocol = http
    .baseUrl("http://localhost:9999")
    .userAgentHeader("Agente do Caos - 2024 Q1")

  val creditos = scenario("Créditos")
    .exec(
      http("créditos")
      .post(_ => s"/clientes/${randomClienteId()}/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(_ => s"""{ "valor": ${randomValorCredito()} }"""))
          .check(status.is(200))
  )

  val debitos = scenario("Débitos")
    .exec(
      http("débitos")
      .post(_ => s"/clientes/${randomClienteId()}/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(_ => s"""{ "valor": ${randomValorDebito()} }"""))
          .check(status.in(200, 422))
  )

  val saldos = scenario("Saldos")
    .exec(
      http("saldos")
      .get(_ => s"/clientes/${randomClienteId()}/saldo")
          .check(jmesPath("inconsistente").is("false"))
  )

  setUp(
    creditos.inject(
      rampUsersPerSec(1).to(100).during(20.seconds),
      constantUsersPerSec(100).during(3.minutes)
    ),
    debitos.inject(
      rampUsersPerSec(1).to(200).during(20.seconds),
      constantUsersPerSec(200).during(3.minutes)
    ),
    saldos.inject(
      rampUsersPerSec(1).to(20).during(20.seconds),
      constantUsersPerSec(20).during(3.minutes)
    )
  ).protocols(httpProtocol)
}
