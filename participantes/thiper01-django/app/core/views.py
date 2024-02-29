import json
from .models import Saldos, Transacoes
from django.http import HttpResponse, JsonResponse
from django.utils import timezone
from django.core.exceptions import ValidationError
from django.db import transaction
from .utils import get_cliente, get_info, get_last_tran


def transacoes(request, id):
    if request.method == "POST":
        cliente = get_cliente(id)
        try:
            body = json.loads(request.body)
        except:
            response = HttpResponse()
            response.status_code = 422
            return response
        
        valor_tran = body["valor"]
        tipo = body["tipo"]
        descr = body["descricao"]
        transacao = Transacoes(cliente=cliente, valor=valor_tran, tipo=tipo, descricao=descr)
        try:
            transacao.clean_fields(exclude=["cliente","realizada_em"])
        except ValidationError as e:
            erro = " \n".join(e.messages)
            response = HttpResponse(erro)
            response.status_code = 422
            return response

        with transaction.atomic():
            saldo = Saldos.objects.select_for_update().get(cliente=id)
            if tipo == "d":
                if (saldo.valor+cliente.limite)-valor_tran < 0:
                    response = HttpResponse()
                    response.status_code = 422
                    return response
                else:
                    saldo.valor -= valor_tran
                    saldo.save()
            else:
                saldo.valor += valor_tran
                saldo.save()
            
            transacao.save()
        response = JsonResponse({
            "limite": cliente.limite,
            "saldo": saldo.valor})
        response.status_code = 200
        return response
    
    else:
        response = HttpResponse()
        response.status_code = 400
        return response

def extrato(request, id):
    if request.method == "GET":
        try:
            with transaction.atomic():
                cliente, saldo = get_info(id)
                last_tran = get_last_tran(id)
        except:
                response = HttpResponse()
                response.status_code = 404
                return response
            
        response = JsonResponse(
            {
                "saldo": {
                    "total": saldo.valor,
                    "data_extrato": timezone.now(),
                    "limite": cliente.limite
                },
                "ultimas_transacoes": last_tran
            })
        response.status_code = 200
        return response
    else:
        response = HttpResponse()
        response.status_code = 400
        return response
