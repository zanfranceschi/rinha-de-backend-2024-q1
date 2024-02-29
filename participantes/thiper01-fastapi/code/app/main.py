import datetime
from fastapi import FastAPI, HTTPException, Depends
from enum import Enum

from .crud import get_extrato, get_info, get_cliente, get_saldo_for_update, create_transaction
from .schemas import TransacaoBase
from sqlalchemy.orm import Session
from .database import SessionLocal
from sqlalchemy import desc, select
from . import models, schemas


app = FastAPI()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def root():
    return {"message": "Hello World"}

@app.post("/clientes/{id}/transacoes")
def transacoes(transacao: TransacaoBase, id: int, db: Session = Depends(get_db)):
    transacao.model_dump()
    valor_tran = transacao.valor
    with db.begin():
        try:
            cliente = get_cliente(db, id)
        except:
            raise HTTPException(status_code=404)
        
        saldo = db.query(models.Saldos).filter(models.Saldos.cliente_id == id).with_for_update().one() #get_saldo_for_update(db, id)

        if transacao.tipo == "d":
            if (saldo.valor+cliente.limite)-valor_tran < 0: # type: ignore
                raise HTTPException(status_code=422)
            else:
                saldo.valor -= valor_tran # type: ignore
        else:
            saldo.valor += valor_tran # type: ignore
        
        create_transaction(db, transacao, id)

    response = {
        "limite": cliente.limite, # type: ignore
        "saldo": saldo.valor} # type: ignore
    return response

@app.get("/clientes/{id}/extrato")
def extrato(id: int, db: Session = Depends(get_db)):
    with db.begin():
        try:
            cliente, saldo = get_info(db ,id)
        except:
            raise HTTPException(status_code=404)
            
        last_tran = get_extrato(db, id)
    response = {
        "saldo": {
            "total": saldo,
            "data_extrato": datetime.datetime.now(datetime.timezone.utc),
            "limite": cliente.limite # type: ignore
        },
        "ultimas_transacoes": last_tran
    }
    return response
