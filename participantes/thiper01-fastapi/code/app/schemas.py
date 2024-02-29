from pydantic import BaseModel, Field
from datetime import datetime


### Pydantic orm models ###
class TransacaoBase(BaseModel):
    valor: int
    tipo: str = Field(pattern="[cd]")
    descricao: str = Field(max_length=10, min_length=1, description="A descricao deve tem no máximo 10 caracteres")

class Transacao(TransacaoBase):
    id: int
    cliente_id: int
    realizada_em: datetime

    class Config:
        orm_mode = True

class Saldo(BaseModel):
    id: int
    cliente_id: int
    valor: int

    class Config:
        orm_mode = True

class Cliente(BaseModel):
    id: int
    nome: str
    limite: int

    class Config:
        orm_mode = True
