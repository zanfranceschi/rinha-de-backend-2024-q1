from django.urls import path
from .views import transacoes, extrato

urlpatterns = [
    path("<int:id>/transacoes", transacoes),
    path("<int:id>/extrato", extrato),
]
