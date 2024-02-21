from tortoise.models import Model
from tortoise import fields
from tortoise.contrib.pydantic import pydantic_model_creator, pydantic_queryset_creator
from tortoise.transactions import atomic
from pydantic import BaseModel, Field
from typing import Literal
from models.cliente import Cliente
import datetime
import pytz

class Transaction_pydantic(BaseModel):
    valor: int = Field(...,gt=0)
    tipo: Literal['c','d']
    descricao: str = Field(..., max_length=10, min_length=1)

class Transaction(Model):
    cliente_id = fields.IntField(blank=False, null=False)
    valor = fields.IntField(blank=False, null=False)
    tipo = fields.CharField(max_length=1, blank=False, null=False)
    descricao = fields.CharField(max_length=10, blank=False, null=False)
    realizada_em = fields.DatetimeField(auto_now_add=True)
    
    @staticmethod
    @atomic()
    async def execute_transaction(cliente_id:int, valor:int, tipo: str, descricao: str):
            
        cliente = await Cliente.select_for_update().filter(id=cliente_id).first()
        if not cliente:
            return (404,'Cliente não existe na base de dados')
            
        novo_saldo = (cliente.saldo + valor) if tipo=='c' else (cliente.saldo-valor)
        
        if novo_saldo < cliente.limite * -1:
            return(422,'Cliente não possui saldo suficiente')
        
        transac = await Transaction(cliente_id=cliente_id, valor=valor, tipo=tipo, descricao=descricao)
        cliente.saldo = novo_saldo
        await cliente.save()
        await transac.save()
        
        return (200,{'limite':cliente.limite, 'saldo':cliente.saldo}) 
        

    @staticmethod
    async def get_extract(cliente_id: int):
        cliente = await Cliente.filter(id=cliente_id).first()
        if not cliente:
            return (404,'Cliente não existe na base de dados')
        
        transactions = await Transaction.filter(cliente_id = cliente_id).order_by('-realizada_em').limit(10)
        ultimas_transacoes = [{'valor':t.valor, 'tipo':t.tipo, 'descricao':t.descricao,'realizada_em':t.realizada_em.isoformat()} for t in transactions]
        ret_extrato = {'saldo':{'total':cliente.saldo,'data_extrato':datetime.datetime.now().isoformat() ,'limite':cliente.limite},'ultimas_transacoes':ultimas_transacoes}
        
        return (200,ret_extrato)
        
    def __str__(self):
        return self.id

# Cliente_pydantic = pydantic_model_creator(Cliente)
# Cliente_pydanticList = pydantic_queryset_creator(Cliente)
#Transaction_pydantic = pydantic_model_creator(Transaction, exclude=('id','cliente_id','realizada_em'))
# Transaction_pydanticList = pydantic_queryset_creator(Transaction)
        