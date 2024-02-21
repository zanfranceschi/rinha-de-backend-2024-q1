from fastapi import FastAPI, HTTPException
from starlette.responses import JSONResponse
from tortoise import Tortoise
from models.transaction import Transaction, Transaction_pydantic
from tortoise.contrib.fastapi import register_tortoise
import os

app = FastAPI()

@app.post('/clientes/{cliente_id}/transacoes')
async def createTransaction(cliente_id: int, transacao:Transaction_pydantic):
    retcode, resp = await Transaction.execute_transaction(cliente_id, transacao.valor, transacao.tipo, transacao.descricao)
    return JSONResponse(status_code = retcode, content= resp)

@app.get('/clientes/{cliente_id}/extrato')
async def getTransactionsByClientID(cliente_id: int):
    retcode, resp = await Transaction.get_extract(cliente_id)
    return JSONResponse(status_code = retcode, content= resp)
    
register_tortoise(
    app,
    db_url ='asyncpg://admin:rinha2024@%s:5432/rinha' % os.getenv('DB_HOSTNAME'),
    modules ={'models': ['models.cliente','models.transaction']},
    generate_schemas = False,
    add_exception_handlers = False,
)