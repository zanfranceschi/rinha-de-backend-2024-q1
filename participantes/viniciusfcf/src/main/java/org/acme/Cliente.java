package org.acme;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
public class Cliente extends PanacheEntityBase {
    
    @Id
    @GeneratedValue
    public Integer id;

    public Integer limite;

    public Integer saldo;
}
