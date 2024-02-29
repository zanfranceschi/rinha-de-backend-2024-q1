from sqlalchemy.orm import Session
from sqlalchemy import desc, select
from . import models, schemas

def get_cliente(db: Session, id: int):
    return db.query(models.Clientes).filter(models.Clientes.id == id).first()

def get_saldo_for_update(db: Session, user_id: int):
    return db.execute(select(models.Saldos.valor).filter(models.Saldos.cliente_id == user_id).with_for_update()).first()

def get_info(db: Session, user_id: int):
    cliente = db.query(models.Clientes).filter(models.Clientes.id == user_id).first()
    saldo = db.execute(select(models.Saldos.valor).filter(models.Saldos.cliente_id == user_id)).first()
    return cliente, saldo.valor

def get_extrato(db: Session, user_id: int):
    
    queryRes = db.execute(
        select(models.Transacoes.valor, models.Transacoes.tipo, models.Transacoes.descricao, models.Transacoes.realizada_em).where(models.Transacoes.cliente_id == user_id).order_by(desc(models.Transacoes.realizada_em)).limit(10)
        ).all()
    ultimasTran = []
    for u in queryRes:
        ultimasTran.append(u._mapping)
    return ultimasTran #db.query(models.Transacoes.valor, models.Transacoes.tipo, models.Transacoes.descricao, models.Transacoes.realizada_em).filter(models.Transacoes.cliente_id == user_id).order_by(desc(models.Transacoes.realizada_em)).limit(10).all().keys()

def create_transaction(db: Session, transacao: schemas.TransacaoBase, id: int):
    db_transacao = models.Transacoes(**transacao.model_dump(), cliente_id=id)
    db.add(db_transacao)
    return