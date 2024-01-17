import scala.concurrent.duration._

import scala.util.Random

import util.Try

import io.gatling.commons.validation._
import io.gatling.core.session.Session
import io.gatling.core.Predef._
import io.gatling.http.Predef._


class RinhaBackendCrebitosSimulation
  extends Simulation {

  /*
    ATENÇÃO: Este não é o teste final da Rinha!!!

      Essa simulação é apenas uma amostra do que será testado e serve
      para facilitar que você teste sua API se não souber (ou quiser)
      como fazê-lo. Fique à vontade para alterar e testar diferentes
      aspectos.

    
    Como executar os testes/simulação:
      1. Baixe o Gatling em https://gatling.io/open-source/
      2. Certifique-se de que tenha o JDK instalado
          (64bits OpenJDK LTS (Long Term Support) versions: 11, 17 e 21)
          https://gatling.io/docs/gatling/tutorials/installation/
      3. Configure o script run-test.sh (ou run-test.ps1 se estiver no Windows)
      4. Suba sua API (ou load balancer) na porta 9999
      5. Execute ./run-test.sh (ou run-test.ps1 se estiver no Windows)
      6. Agora é só aguardar o teste terminar e abrir o relatório
          O caminho do relatório é exibido ao término da simulação.
          Os relatórios são salvos em './user-files/results'
      
      De nada :)
  */
  
  def randomClienteId() = Random.between(1, 5 + 1)
  def randomValorTransacao() = Random.between(1, 10000 + 1)
  def randomTipoTransacao() = Seq("c", "d", "d")(Random.between(0, 2 + 1))
  def toInt(s: String): Option[Int] = {
    try {
      Some(s.toInt)
    } catch {
      case e: Exception => None
    }
  }

  val descricoes = Map("c" -> "crédito", "d" -> "débito")

  val validarConsistenciaSaldoLimite = (valor: Option[String], session: Session) => {
    /*
      Essa função é frágil porque depende de que haja uma entrada
      chamada 'limite' com valor conversível para int na session
      e também que seja encadeada com com jmesPath("saldo") para
      que 'valor' seja o primeiro argumento da função validadora
      de 'validate(.., ..)'.
      
      =============================================================
      
      Nota para quem não tem experiência em testes de performance:
        O teste de lógica de saldo/limite extrapola o que é comumente 
        feito em testes de performance apenas por causa da natureza
        da Rinha de Backend. Evite fazer esse tipo de coisa em 
        testes de performance, pois não é uma prática recomendada
        normalmente.
    */ 

    val saldo = valor.flatMap(s => Try(s.toInt).toOption)
    val limite = toInt(session("limite").as[String])

    (saldo, limite) match {
      case (Some(s), Some(l)) if s.toInt < l.toInt * -1 => Failure("Limite ultrapassado!")
      case (Some(s), Some(l)) if s.toInt >= l.toInt * -1 => Success(Option("ok"))
      case _ => Failure("WTF?!")
    }
  }

  val httpProtocol = http
    .baseUrl("http://localhost:9999")
    .userAgentHeader("Agente do Caos - 2024 Q1")

  val transacoes = scenario("Transações")
    .exec {s =>
      val cliente_id = randomClienteId()
      val valor = randomValorTransacao()
      val tipo = randomTipoTransacao()
      val descricao = descricoes.get(tipo)
      val payload = s"""{"valor": ${valor}, "tipo": "${tipo}", "descricao": "${descricao}"}"""
      val session = s.setAll(Map("descricao" -> descricao, "cliente_id" -> cliente_id, "payload" -> payload))
      session
    }
    .exec(
      http("transações")
      .post(s => s"/clientes/${s("cliente_id").as[String]}/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s => s("payload").as[String]))
          .check(status.in(200, 422))
    )

  val extratos = scenario("Extratos")
    .exec(
      http("extratos")
      .get(s => s"/clientes/${randomClienteId()}/extrato")
      .check(
        jmesPath("saldo.limite").saveAs("limite"),
        jmesPath("saldo.total")
          .validate(
            "ConsistenciaSaldoLimite - Extratos",
            validarConsistenciaSaldoLimite)
    )
  )

  setUp(
    transacoes.inject(
      rampUsersPerSec(1).to(200).during(20.seconds),
      constantUsersPerSec(200).during(3.minutes)
    ),
    extratos.inject(
      rampUsersPerSec(1).to(20).during(20.seconds),
      constantUsersPerSec(20).during(3.minutes)
    )
  ).protocols(httpProtocol)
}
