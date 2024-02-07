package io.github.gasparbarancelli;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.quarkus.runtime.annotations.RegisterForReflection;

import java.time.LocalDateTime;
import java.util.List;

@RegisterForReflection
public record ExtratoResposta(
        ExtratoSaldoResposta saldo,
        @JsonProperty("ultimas_transacoes")
        List<ExtratoTransacaoResposta> transacoes) {

    @RegisterForReflection
    public record ExtratoSaldoResposta(
            int total,
            @JsonProperty("data_extrato")
            @JsonFormat(pattern = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
            LocalDateTime data,
            int limite) {

    }

    @RegisterForReflection
    public record ExtratoTransacaoResposta(
            int valor,
            TipoTransacao tipo,
            String descricao,
            @JsonProperty("realizada_em")
            @JsonFormat(pattern = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
            LocalDateTime data) {

        public static ExtratoTransacaoResposta gerar(Transacao transacao) {
            return new ExtratoResposta.ExtratoTransacaoResposta(
                    transacao.getValor(),
                    transacao.getTipo(),
                    transacao.getDescricao(),
                    transacao.getData());
        }

    }


}
