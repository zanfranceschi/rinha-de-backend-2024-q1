package org.acme;

public class Transacao {

    public Integer valor;

    public Character tipo;

    public String descricao;

    public boolean ehValida() {
        return valor != null
            && tipo != null
            && descricao != null
            && valor > 0
            && (tipo == 'c' || tipo == 'd')
            && descricao.length() > 0 
            && descricao.length() <= 10
            ;
    }

}
