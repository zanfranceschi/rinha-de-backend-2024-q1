import json
import os
from datetime import datetime
from fastapi import FastAPI
from fastapi import Request, Response
import psycopg2
from contextlib import asynccontextmanager


@asynccontextmanager
async def lifespan(app: FastAPI):
    global conn
    while True:
        try:
            conn = psycopg2.connect(
                host=os.getenv('DB_HOST'),
                port='5432',
                user='admin',
                password='rinha',
                database='rinha',
            )
            break
        except psycopg2.OperationalError:
            pass
    conn.set_session(autocommit=True)

    yield

    conn.close()


app = FastAPI(lifespan=lifespan)


@app.put('/reset_db/')
def reset_database():
    db = conn.cursor()
    db.execute('CALL reset_db();')
    return Response(status_code=200)


@app.post('/clientes/{id}/transacoes')
async def set_transacao(id: int, request: Request):
    body = await request.json()

    if not str(body['tipo']).lower() in ['c', 'd']:
        return Response(status_code=422)

    if not type(body['valor']) == int:
        return Response(status_code=422)

    if not body['descricao'] or not 1 <= len(str(body['descricao'])) <= 10:
        return Response(status_code=422)

    db = conn.cursor()
    try:
        query = {
            'c': f"SELECT creditar({id}, {body['valor']}, '{body['descricao']}');",
            'd': f"SELECT debitar({id}, {body['valor']}, '{body['descricao']}');",
        }[body['tipo']]
        db.execute(query)
        content = db.fetchone()[0]
    except psycopg2.IntegrityError:
        return Response(status_code=422)
    except psycopg2.DataError:
        return Response(status_code=404)

    return Response(
        status_code=200,
        content=json.dumps(content),
        media_type='application/json'
    )


@app.get('/clientes/{id}/extrato')
async def get_extrato(id: int):
    db = conn.cursor()

    db.execute(f"SELECT saldo, limite, valor, tipo, descricao, realizada_em "
               f"FROM cliente LEFT JOIN transacao ON cliente.id = transacao.cliente_id "
               f"WHERE cliente.id = {id} "
               f"ORDER BY realizada_em DESC LIMIT 10;")

    lista_transacoes = db.fetchall()

    if not lista_transacoes:
        return Response(status_code=404)

    content = {
        'saldo': {
            'total': lista_transacoes[0][0],
            'limite': lista_transacoes[0][1],
            'data_extrato': str(datetime.now())
        },
        'ultimas_transacoes': []
    }

    for transacao in lista_transacoes:
        if transacao[2]:
            content['ultimas_transacoes'].append({
                "valor": transacao[2],
                "tipo": transacao[3],
                "descricao": transacao[4],
                "realizada_em": str(transacao[5])
            })

    return Response(
        status_code=200,
        content=json.dumps(content),
        media_type='application/json'
    )
