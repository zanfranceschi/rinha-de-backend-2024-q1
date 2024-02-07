package io.github.gasparbarancelli;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public record TransacaoResposta(int limite, int saldo) {
}
