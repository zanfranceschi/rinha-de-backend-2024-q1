package org.acme;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import io.quarkus.runtime.annotations.RegisterForReflection;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
@RegisterForReflection
public class Cliente extends PanacheEntityBase {
    
    @Id
    @GeneratedValue
    public Integer id;

    public Integer limite;

    public Integer saldo;
}
