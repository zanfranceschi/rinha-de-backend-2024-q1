package org.acme;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import io.quarkus.runtime.annotations.RegisterForReflection;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
@RegisterForReflection
public class SaldoCliente extends PanacheEntityBase {
    
    @Id
    public Integer id;

    public int saldo;

    public int limite;
}
