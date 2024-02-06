package org.acme;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public class Saldo {
    
    @JsonFormat(pattern = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'")
    public LocalDateTime data_extrato;
    public Integer total;
    public Integer limite;
}
