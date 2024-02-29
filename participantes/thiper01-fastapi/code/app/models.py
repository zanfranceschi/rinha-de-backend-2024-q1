from .database import Base
from sqlalchemy import Column, ForeignKey, Integer, String, CHAR, TIMESTAMP
from sqlalchemy.orm import relationship
from sqlalchemy.schema import FetchedValue


### SQLAlchemy models ###

class Clientes(Base):
    __tablename__ = "clientes"

    id = Column(Integer, primary_key=True)
    nome = Column(String(50), nullable=False)
    limite = Column(Integer, nullable=False)
    saldo = relationship("Saldos", back_populates="cliente")
    transacoes = relationship("Transacoes", back_populates="cliente")


class Saldos(Base):
    __tablename__ = "saldos"

    id = Column(Integer, primary_key=True)
    cliente_id = Column(ForeignKey("clientes.id"), nullable=False)
    valor = Column(Integer, nullable=False)

    cliente = relationship("Clientes", back_populates="saldo")


class Transacoes(Base):
    __tablename__ = "transacoes"

    id = Column(Integer, primary_key=True)
    cliente_id = Column(ForeignKey("clientes.id"), nullable=False)
    valor = Column(Integer, nullable=False)
    tipo = Column(CHAR(1), nullable=False)
    descricao = Column(String(10), nullable=False)
    realizada_em = Column(TIMESTAMP, server_default=FetchedValue())

    cliente = relationship("Clientes", back_populates="transacoes")
