package io.github.gasparbarancelli;

import io.quarkus.runtime.annotations.RegisterForReflection;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "TRANSACAO")
@RegisterForReflection
public class Transacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "CLIENTE_ID")
    private int cliente;

    private int valor;

    @Enumerated(EnumType.STRING)
    private TipoTransacao tipo;

    private String descricao;

    private LocalDateTime data;

    public int getId() {
        return id;
    }

    public Transacao() {
    }

    public Transacao(int cliente, int valor, TipoTransacao tipo, String descricao) {
        this.cliente = cliente;
        this.valor = valor;
        this.tipo = tipo;
        this.descricao = descricao;
        this.data = LocalDateTime.now();
    }

    public int getCliente() {
        return cliente;
    }

    public int getValor() {
        return valor;
    }

    public TipoTransacao getTipo() {
        return tipo;
    }

    public String getDescricao() {
        return descricao;
    }

    public LocalDateTime getData() {
        return data;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Transacao transacao = (Transacao) o;
        return id == transacao.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
