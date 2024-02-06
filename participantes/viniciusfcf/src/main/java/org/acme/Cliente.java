package org.acme;

import org.hibernate.annotations.Immutable;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import io.quarkus.runtime.annotations.RegisterForReflection;
import jakarta.persistence.Cacheable;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Entity
@RegisterForReflection
@Immutable
@Cacheable
public class Cliente extends PanacheEntityBase {
    
    @Id
    @GeneratedValue
    public Integer id;

    public Integer limite;

}
