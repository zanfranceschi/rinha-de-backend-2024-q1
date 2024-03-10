import requests
import os
import sys
import json
from flask import Flask, jsonify, request
import psycopg
import time
app = Flask(__name__)
port = int(os.environ.get('PORT', 5000))
database_host = os.environ.get('DATABASE_HOST','localhost')
connection_string = f"postgresql://root:1234@{database_host}:5432/rinhadb"
if __name__ == "__main__":
    print(f'olo mundo')
    app.run(debug=True, host="0.0.0.0", port=port)

def inicializar_db():
    # Ver se a flag que indica que o banco já foi inicializado já foi setada
    ja_inicializei = app.config.get('JA_INICIALIZEI')
    
    if not ja_inicializei:
        # Antes de inicializar o banco, verificar se as tabelas já existem
        with psycopg.connect(connection_string, autocommit = False) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1 as tot FROM information_schema.tables WHERE table_schema = %s AND table_type = %s AND table_name = %s", ('public', 'BASE TABLE', 'clientes'))
                if cur.rowcount > 0: # Se maior que zero, tabela já existe 
                    app.config.update(
                        JA_INICIALIZEI=True
                    )
                    cur.close()
                    conn.close()
                    return 0
        # Então, inicializar o banco 
            # Ler o arquivo com o script de inicialização
            with open('./db-init.sql', 'r') as sql_file:
                sql_script = sql_file.read()
            conn.execute(sql_script)
            conn.commit()
            conn.close()
        app.config.update(
            JA_INICIALIZEI=True
        )

# quando a request chama na raiz 
@app.route("/")
def home():
    inicializar_db()

    return f'olá mundo'

@app.route('/clientes/<int:id>/transacoes', methods=['POST'])
def transacao(id):
    inicializar_db()

    # Get data from request body
    data = request.get_json()  
    print(f"Id={id}")

    # 1) Tratamos todos os parâmetros da função
    # tratando id 
    if id < 1:
        print(f'Id={id} precisa ser inteiro positivo.')
        return f'Id={id} precisa ser inteiro positivo.\n', 439

    # tratando valor
    if "valor" in data:
        valor = data["valor"]
        if not isinstance(valor, int):
            print(f'Valor={valor} não é um número inteiro')
            return f'Valor={valor} não é um número inteiro.\n', 436
        if valor < 1:
            print(f'Valor={valor} precisa ser inteiro positivo.')
            return f'Valor={valor} precisa ser inteiro positivo.\n', 434
        print(f"Valor={valor}")
    else:
        print("Valor não fornecido")
        return f'Valor faltando\n', 432
    
    # tratando tipo
    if "tipo" in data:
        tipo = data["tipo"]
        # Fail if tipo is not equal to 'c' neither 'd'
        if tipo != 'c' and tipo != 'd':
            print(f'Tipo={tipo} não é c ou d')
            return f'Tipo={tipo} não é c ou d.\n', 437
        print(f"Tipo={tipo}")
    else:
        print("Tipo não fornecido")
        return f'Tipo faltando\n', 433
    
    # tratando descricao
    if "descricao" in data:
        descricao = data["descricao"]
        # Fail if the lenght of descricao is zero or more than 10
        if len(descricao) == 0 or len(descricao) > 10:
            print(f'Descricao={descricao} tem comprimento zero ou mais que 10')
            return f'Descricao={descricao} tem comprimento zero ou mais que 10.\n', 438
        print(f"Descricao={descricao}")
    else:
        print("Descricao não fornecida")
        return f'Descricao faltando\n', 435
        
    # 2) Pegar o saldo e limite do cliente 
    with psycopg.connect(connection_string, autocommit = False) as conn:
        with conn.cursor() as cur: # Open a cursor to perform database operations
            cur.execute("select saldo, limite from clientes where id = %s", (id,))
            if cur.rowcount == 0:
                print(f'Id={id} não localizado no banco.')
                return f'Id={id} não localizado no banco.\n', 441
            else:
                saldo, limite = cur.fetchone()
                print(f'Id={id} até então tem saldo {saldo}.')
            # cur.close()

    # 3) Testar consistência do saldo e limite do cliente
            if tipo == 'd':
                if saldo - valor < (limite * -1):
                    print(f'Limite excedido. Com débito de {valor}, novo saldo {saldo-valor} excederia limite atual de {limite}.')
                    dicts = [
                        {'erro': f'Limite excedido. Com débito de {valor}, novo saldo {saldo-valor} excederia limite atual de {limite}.\n' }
                    ]
                    response_json = json.dumps(dicts)
                    return response_json, 442

    # 4) Comittar a transação no banco 
            cur.execute(
                "insert into transacoes ( id, valor, tipo, description, realizada_em ) values ( %s, %s, %s, %s, CURRENT_TIMESTAMP )", 
                (id, valor, tipo, descricao))
            novosaldo=0
            if tipo == 'd':
                novosaldo = saldo - valor
            else:
                novosaldo = saldo + valor
            cur.execute("update clientes set saldo = %s where id = %s", (novosaldo, id))
            # print(f'cur.rowcount={cur.rowcount}')
            conn.commit()

            # return f'Transação inserida\n', 200

            # if cur.rowcount == 0:
            #     print(f'Id={id} não localizado no banco.')
            #     return f'Id={id} não localizado no banco.\n', 440
            # else:
            #     saldo, limite = cur.fetchone()
            #     print(f'Id={id} tem saldo {saldo}.')

    # Compor resposta
    dicts = [
        {'limite': limite, 'saldo': novosaldo}
    ]
    response_json = json.dumps(dicts)
    return response_json, 200

    # return f'Recebido {id}, tipo {tipo}, valor {valor}, descricao {descricao}.\n', 201

@app.route('/clientes/<int:id>/extrato', methods=['GET'])
def extrato(id):
    inicializar_db()

    # time.sleep(3)

    # Primeiro tratamos o parâmetro da função, o id
    if id < 1:
        print(f'Id={id} precisa ser inteiro positivo.')
        return f'Id={id} precisa ser inteiro positivo.\n', 439

    # Então, pegamos o saldo do cliente 
    with psycopg.connect(connection_string, autocommit = False) as conn:
        # Open a cursor to perform database operations
        with conn.cursor() as cur:
            # Query the database and obtain data as Python objects.
            cur.execute("select saldo, limite from clientes where id = %s", (id,))
            if cur.rowcount == 0:
                print(f'Cliente Id={id} não existe.')
                return f'Cliente Id={id} não existe.\n', 445
            else:
                saldo, limite = cur.fetchone()
                print(f'Id={id} tem saldo {saldo}.')


    # Depois, as últimas 10 transações 
            cur.execute("select valor, tipo, description, realizada_em from transacoes where id = %s order by realizada_em desc LIMIT 10", (id,))
            dict_transacoes = []
            while True:
                row = cur.fetchone()
                # print(f'cur.rowcount == {cur.rowcount}.')

                if row is None:
                    break
                # process row
                valor, tipo, description, realizada_em = row
                transacaon = {'valor': valor, 'tipo': tipo, 'descricao': description, 'realizada_em': realizada_em.strftime("%Y-%m-%dT%H:%M:%S.%fZ")}
                # print(f'Valor={valor}, tipo={tipo}, description={description}, realizada_em={realizada_em}.')
                dict_transacoes.append(transacaon)
                # print(f'Transação adicionada no dicionário.')
                                    
                if cur.rowcount == 0:
                    break
            
            # print(f'Id={id} listei as transações.')
            # return f'Id={id} listei as transações.\n', 444
            cur.close()
        conn.close()
                
    # E mandamos a resposta. 
    saldo = {'total': saldo, 'data': realizada_em.strftime("%Y-%m-%dT%H:%M:%S.%fZ"), 'limite': limite}
    # transacao1 = {'valor': '999', 'tipo': 'c', 'descricao': 'aaaaa', 'realizada_em': 'aaaaa'}
    # transacao2 = {'valor': '998', 'tipo': 'c', 'descricao': 'bbbbb', 'realizada_em': 'bbbbb'}
    # dict_transacoes = [
    #     transacao1,
    #     transacao2
    # ]
    response_json = {
        "saldo": saldo,
        "ultimas_transacoes": dict_transacoes
    }
    return response_json, 200
