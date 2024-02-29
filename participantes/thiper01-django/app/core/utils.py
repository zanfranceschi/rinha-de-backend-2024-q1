# import asyncio
from django.core.cache import cache
from .models import Clientes, Saldos, Transacoes
from django.shortcuts import get_object_or_404


def get_cliente(key):
    cached_cliente = cache.get(str(key))
    if cached_cliente is not None:
        return cached_cliente
    
    cliente = get_object_or_404(Clientes, id=key)
    cache.set(str(key) , cliente, 3600)
    return cliente

def get_info(id):
    cached_cliente = cache.get(str(id))
    if cached_cliente is not None:
        saldo = Saldos.objects.get(cliente=id)
        return cached_cliente, saldo
    
    saldo = Saldos.objects.select_related("cliente").get(cliente=id)
    cliente = saldo.cliente
    cache.set(str(id) , cliente, 3600)
    return cliente, saldo

def get_last_tran(id):
    return list(Transacoes.objects.filter(cliente=id).order_by("-realizada_em")[:10].values("valor", "tipo", "descricao", "realizada_em"))
