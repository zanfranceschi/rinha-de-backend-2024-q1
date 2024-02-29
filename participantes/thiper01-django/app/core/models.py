from django.db import models
from django.core.validators import MaxLengthValidator
from .customModelFields import StrictIntegerField
# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.

class Clientes(models.Model):
    id = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=50, null=False, validators=[MaxLengthValidator(50)])
    limite = models.IntegerField(null=False)

    class Meta:
        managed = False
        db_table = 'clientes'


class Saldos(models.Model):
    id = models.AutoField(primary_key=True)
    cliente = models.OneToOneField(Clientes, models.CASCADE)
    valor = models.IntegerField(null=False)

    class Meta:
        managed = False
        db_table = 'saldos'


class Transacoes(models.Model):
    id = models.AutoField(primary_key=True)
    tipoChoices=[
        ("c", "Crédito"), 
        ("d", "Débito")]
    cliente = models.ForeignKey(Clientes, models.DO_NOTHING)
    valor = StrictIntegerField(null=False)
    tipo = models.CharField(max_length=1, null=False, choices=tipoChoices)
    descricao = models.CharField(max_length=10, null=False, validators=[MaxLengthValidator(10)])
    realizada_em = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'transacoes'
