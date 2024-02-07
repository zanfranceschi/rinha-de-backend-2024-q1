package io.github.gasparbarancelli;

import java.util.Objects;
import java.util.function.Predicate;

public class Valida {

    private Valida() {
    }

    public static Predicate<String> valor = (valor) -> {
        if (Objects.isNull(valor)) {
            return false;
        }

        try {
            var intValue = Integer.parseInt(valor);
            return intValue > 0;
        } catch (Exception e) {
            return false;
        }
    };

    public static Predicate<String> descricao = (descricao) ->
            Objects.nonNull(descricao)
            && !descricao.isEmpty()
            && descricao.length() <= 10;

}
