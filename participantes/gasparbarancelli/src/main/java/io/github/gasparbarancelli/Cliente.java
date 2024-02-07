package io.github.gasparbarancelli;

import io.quarkus.runtime.annotations.RegisterForReflection;
import jakarta.persistence.*;

import java.util.Objects;


@Entity
@Table(name = "CLIENTE")
@RegisterForReflection
public class Cliente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    private int limite;

    private int saldo;

    public Cliente() {
    }

    public int getLimite() {
        return limite;
    }

    public int getSaldo() {
        return saldo;
    }

    public void atualizaSaldo(int valor, TipoTransacao tipoTransacao) {
        if (TipoTransacao.d.equals(tipoTransacao)) {
            saldo = saldo - valor;
        } else {
            saldo = saldo + valor;
        }
    }

    public int getSaldoComLimite() {
        return saldo + limite;
    }

    public static boolean naoExiste(int id) {
        return id < 1 || id > 5;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Cliente cliente = (Cliente) o;
        return id == cliente.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
