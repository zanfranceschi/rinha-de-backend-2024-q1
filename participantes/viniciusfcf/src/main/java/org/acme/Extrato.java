package org.acme;

import java.util.ArrayList;
import java.util.List;

import io.quarkus.runtime.annotations.RegisterForReflection;

@RegisterForReflection
public class Extrato {

    public Saldo saldo = new Saldo();

    public List<Transacao> ultimas_transacoes = new ArrayList<>();
    

}