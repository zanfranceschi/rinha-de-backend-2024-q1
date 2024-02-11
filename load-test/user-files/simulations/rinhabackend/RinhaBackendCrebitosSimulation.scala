import scala.concurrent.duration._

import scala.util.Random

import util.Try

import io.gatling.commons.validation._
import io.gatling.core.session.Session
import io.gatling.core.Predef._
import io.gatling.http.Predef._


class RinhaBackendCrebitosSimulation
  extends Simulation {

  def randomClienteId() = Random.between(1, 5 + 1)
  def randomValorTransacao() = Random.between(1, 10000 + 1)
  def randomDescricao() = Random.alphanumeric.take(10).mkString
  def randomTipoTransacao() = Seq("c", "d", "d")(Random.between(0, 2 + 1)) // not used
  def toInt(s: String): Option[Int] = {
    try {
      Some(s.toInt)
    } catch {
      case e: Exception => None
    }
  }

  val REQ_PARALELA_ID_CLIENTE = 1
  val REQ_PARALELA_VALOR_POR_REQUISICAO = 10000
  val REQ_PARALELA_NUM_REQUISICOES = 10
  val REQ_PARALELA_SALDO_ESPERADO = (REQ_PARALELA_VALOR_POR_REQUISICAO * REQ_PARALELA_NUM_REQUISICOES)

  val DEBITO = "d"
  val CREDITO = "c"

  val validarConsistenciaSaldoLimite = (valor: Option[String], session: Session) => {
    /*
      Essa função é frágil porque depende que haja uma entrada
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
    .userAgentHeader("Agente do Caos - 2024/Q1")

  val debitos = scenario("débitos")
    .exec {s =>
      val descricao = randomDescricao()
      val cliente_id = randomClienteId()
      val valor = randomValorTransacao()
      val payload = s"""{"valor": ${valor}, "tipo": "d", "descricao": "${descricao}"}"""
      val session = s.setAll(Map("descricao" -> descricao, "cliente_id" -> cliente_id, "payload" -> payload))
      session
    }
    .exec(
      http("débitos")
      .post(s => s"/clientes/${s("cliente_id").as[String]}/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s => s("payload").as[String]))
          .check(
            status.in(200, 422),
            status.saveAs("httpStatus"))
          .checkIf(s => s("httpStatus").as[String] == "200") { jmesPath("limite").saveAs("limite") }
          .checkIf(s => s("httpStatus").as[String] == "200") {
            jmesPath("saldo").validate("ConsistenciaSaldoLimite - Transação", validarConsistenciaSaldoLimite)
          }
    )

  val creditos = scenario("créditos")
    .exec {s =>
      val descricao = randomDescricao()
      val cliente_id = randomClienteId()
      val valor = randomValorTransacao()
      val payload = s"""{"valor": ${valor}, "tipo": "c", "descricao": "${descricao}"}"""
      val session = s.setAll(Map("descricao" -> descricao, "cliente_id" -> cliente_id, "payload" -> payload))
      session
    }
    .exec(
      http("créditos")
      .post(s => s"/clientes/${s("cliente_id").as[String]}/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s => s("payload").as[String]))
          .check(
            status.in(200),
            jmesPath("limite").saveAs("limite"),
            jmesPath("saldo").validate("ConsistenciaSaldoLimite - Transação", validarConsistenciaSaldoLimite)
          )
    )

  val extratos = scenario("extratos")
    .exec(
      http("extratos")
      .get(s => s"/clientes/${randomClienteId()}/extrato")
      .check(
        jmesPath("saldo.limite").saveAs("limite"),
        jmesPath("saldo.total").validate("ConsistenciaSaldoLimite - Extrato", validarConsistenciaSaldoLimite)
    )
  )

  val validarSaldoAposRequisicoesParalelas = (valorFinal: Int) => (saldo: Option[String], session: Session) => {
    saldo match {
      case Some(s) if s.toInt == valorFinal => Success(Option("ok"))
      case _ => Failure("Saldo inconsistente!")
    }
  }

  val converterTipoParaTexto = (tipo: String) => if (tipo == "c") "Crédito" else "Débito"

  val resetarSaldo = (valor: Int, tipo: String) => scenario(s"""${converterTipoParaTexto(tipo)} para resetar saldo""")
    .exec {s =>
      val descricao = "resetar"
      val cliente_id = REQ_PARALELA_ID_CLIENTE
      val payload = s"""{"valor": ${valor}, "tipo": "${tipo}", "descricao": "${descricao}"}"""
      val session = s.setAll(Map("descricao" -> descricao, "cliente_id" -> cliente_id, "payload" -> payload))
      session
    }
    .exec(
      http(s"""${converterTipoParaTexto(tipo)} para resetar saldo""")
      .post(s => s"/clientes/${s("cliente_id").as[String]}/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s => s("payload").as[String]))
          .check(
            status.in(200, 422),
            status.saveAs("httpStatus"))
          .checkIf(s => s("httpStatus").as[String] == "200") { 
            jmesPath("saldo").ofType[Int].is(0)
           }
    )

  val validarExtratoAposRequisicoesParalelas = (saldoEsperado: Int, tipo: String) => scenario(s"""Validação do Extrato ${converterTipoParaTexto(tipo)}""")
    .exec(
      http(s"""Validação do Extrato ${converterTipoParaTexto(tipo)}""")
      .get(s"""/clientes/${REQ_PARALELA_ID_CLIENTE}/extrato""")
      .check(
        jmesPath("saldo.total").validate("ConsistenciaSaldoLimite - Extrato", validarSaldoAposRequisicoesParalelas(saldoEsperado)),
        jsonPath("$.ultimas_transacoes[*]").count.is(REQ_PARALELA_NUM_REQUISICOES)
      )
    )
    .stopInjectorIf(session => "Inconsistência de saldo identificada!", session => session.isFailed)

  val transacoesParalelas = (nome: String, tipo: String) => scenario(nome)
      .exec {s =>
      val descricao = randomDescricao()
      val cliente_id = REQ_PARALELA_ID_CLIENTE
      val valor = REQ_PARALELA_VALOR_POR_REQUISICAO
      val payload = s"""{"valor": ${valor}, "tipo": "${tipo}", "descricao": "${descricao}"}"""
      val session = s.setAll(Map("descricao" -> descricao, "cliente_id" -> cliente_id, "payload" -> payload))
      session
    }
    .exec(
      http(nome)
      .post(s => s"/clientes/${s("cliente_id").as[String]}/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s => s("payload").as[String]))
          .check(
            status.in(200, 422),
            status.saveAs("httpStatus"))
    )
    
  val debitoParalelo = transacoesParalelas("Requisições Paralelas de Débito", DEBITO)
  val creditoParalelo = transacoesParalelas("Requisições Paralelas de Crédito", CREDITO)

  val saldosIniciaisClientes = Array(
    Map("id" -> 1, "limite" ->   1000 * 100),
    Map("id" -> 2, "limite" ->    800 * 100),
    Map("id" -> 3, "limite" ->  10000 * 100),
    Map("id" -> 4, "limite" -> 100000 * 100),
    Map("id" -> 5, "limite" ->   5000 * 100),
  )

  val criteriosClientes = scenario("validações")
    .feed(saldosIniciaisClientes)
    .exec(
      /*
        Os valores de http(...) essão duplicados propositalmente
        para que sejam agrupados no relatório e ocupem menos espaço.
        O lado negativo é que, em caso de falha, pode não ser possível
        saber sua causa exata.
      */ 
      http("validações")
      .get("/clientes/#{id}/extrato")
      .check(
        status.is(200),
        jmesPath("saldo.limite").ofType[String].is("#{limite}"),
        jmesPath("saldo.total").ofType[String].is("0")
      )
    )
    .exec(
      http("validações")
      .get("/clientes/6/extrato")
      .check(status.is(404))
    )
    .exec(
      http("validações")
      .post("/clientes/1/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s"""{"valor": 1, "tipo": "c", "descricao": "toma"}"""))
          .check(
            status.in(200),
            jmesPath("limite").saveAs("limite"),
            jmesPath("saldo").validate("ConsistenciaSaldoLimite - Transação", validarConsistenciaSaldoLimite)
          )
    )
    .exec(
      http("validações")
      .post("/clientes/1/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s"""{"valor": 1, "tipo": "d", "descricao": "devolve"}"""))
          .check(
            status.in(200),
            jmesPath("limite").saveAs("limite"),
            jmesPath("saldo").validate("ConsistenciaSaldoLimite - Transação", validarConsistenciaSaldoLimite)
          )
    )
    .exec(
      http("validações")
      .get("/clientes/1/extrato")
      .check(
        jmesPath("ultimas_transacoes[0].descricao").ofType[String].is("devolve"),
        jmesPath("ultimas_transacoes[0].tipo").ofType[String].is("d"),
        jmesPath("ultimas_transacoes[0].valor").ofType[Int].is("1"),
        jmesPath("ultimas_transacoes[1].descricao").ofType[String].is("toma"),
        jmesPath("ultimas_transacoes[1].tipo").ofType[String].is("c"),
        jmesPath("ultimas_transacoes[1].valor").ofType[Int].is("1")
    )
  )
  .exec(
      http("validações")
      .post("/clientes/1/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s"""{"valor": 1.2, "tipo": "d", "descricao": "devolve"}"""))
          .check(status.in(422))
    )
    .exec(
      http("validações")
      .post("/clientes/1/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s"""{"valor": 1, "tipo": "x", "descricao": "devolve"}"""))
          .check(status.in(422))
    )
    .exec(
      http("validações")
      .post("/clientes/1/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s"""{"valor": 1, "tipo": "c", "descricao": "123456789 e mais um pouco"}"""))
          .check(status.in(422))
    )
    .exec(
      http("validações")
      .post("/clientes/1/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s"""{"valor": 1, "tipo": "c", "descricao": ""}"""))
          .check(status.in(422))
    )
    .exec(
      http("validações")
      .post("/clientes/1/transacoes")
          .header("content-type", "application/json")
          .body(StringBody(s"""{"valor": 1, "tipo": "c", "descricao": null}"""))
          .check(status.in(422))
    )

  /* 
    Separar créditos e débitos dá uma visão
    melhor sobre como as duas operações se
    comportam individualmente.
  */
  setUp(
    criteriosClientes.inject(
      atOnceUsers(1)
    ).andThen(
      debitoParalelo.inject(
        atOnceUsers(10)
      )
      .andThen(
        validarExtratoAposRequisicoesParalelas(REQ_PARALELA_SALDO_ESPERADO * -1, DEBITO).inject(
          atOnceUsers(1)
        )
        .andThen(
          resetarSaldo(REQ_PARALELA_SALDO_ESPERADO, CREDITO).inject(
            atOnceUsers(1)
          )
        )
      ).andThen(
        creditoParalelo.inject(
          atOnceUsers(10)
        ).andThen(
          validarExtratoAposRequisicoesParalelas(REQ_PARALELA_SALDO_ESPERADO, CREDITO).inject(
            atOnceUsers(1)
          ).andThen(
            resetarSaldo(REQ_PARALELA_SALDO_ESPERADO, DEBITO).inject(
              atOnceUsers(1)
            )
          )
        )
      ).andThen(
        debitos.inject(
          rampUsersPerSec(1).to(220).during(2.minutes),
          constantUsersPerSec(220).during(2.minutes)
        ),
        creditos.inject(
          rampUsersPerSec(1).to(110).during(2.minutes),
          constantUsersPerSec(110).during(2.minutes)
        ),
        extratos.inject(
          rampUsersPerSec(1).to(10).during(2.minutes),
          constantUsersPerSec(10).during(2.minutes)
        )
      ),
    )
  ).protocols(httpProtocol)
}
