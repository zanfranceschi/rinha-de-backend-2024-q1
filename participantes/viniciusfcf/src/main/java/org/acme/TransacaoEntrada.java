package org.acme;

import java.time.LocalDateTime;

import org.hibernate.annotations.Immutable;

import com.fasterxml.jackson.annotation.JsonIgnore;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import io.quarkus.runtime.annotations.RegisterForReflection;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@RegisterForReflection
public class TransacaoEntrada {

    public Integer id;

    public String valor;

    public Integer cliente_id;

    public Character tipo;

    public String descricao;

    public boolean ehValida() {
        return valor != null
                && tipo != null
                && descricao != null
                && valorEhInteger()
                && Integer.parseInt(valor) > 0
                && (tipo.equals('c') || tipo.equals('d'))
                && descricao.length() > 0
                && descricao.length() <= 10;
    }

    private boolean valorEhInteger() {
        try {
            Integer.parseInt(valor);
            return true;
        } catch (Exception e) {
            return false;
        }
        
    }

}
