package org.acme;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Transacao extends PanacheEntityBase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @JsonIgnore
    public Integer id;

    public Integer valor;

    @JsonIgnore
    public Integer cliente_id;

    public Character tipo;

    public String descricao;

    @JsonFormat(pattern = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
    public LocalDateTime realizada_em;

    public boolean ehValida() {
        return valor != null
                && tipo != null
                && descricao != null
                && valor > 0
                && (tipo.equals('c') || tipo.equals('d'))
                && descricao.length() > 0
                && descricao.length() <= 10;
    }

}
