package org.acme;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import io.quarkus.runtime.annotations.RegisterForReflection;
import jakarta.persistence.Cacheable;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
@Cacheable
@RegisterForReflection
public class Transacao extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Integer id;

    public Integer valor;

    public Integer cliente_id;

    public Character tipo;

    public String descricao;

    @JsonFormat(pattern = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
    public LocalDateTime realizada_em;

    public int saldo;

    public int limite;

    public static Transacao of(TransacaoEntrada te) {
        Transacao t = new Transacao();
        t.tipo = te.tipo.charAt(0);
        t.cliente_id = te.cliente_id;
        t.descricao = te.descricao;
        t.realizada_em = LocalDateTime.now();
        t.valor = Integer.valueOf(te.valor);
        return t;
    }

}
