from tortoise.models import Model
from tortoise import fields

class Cliente(Model):
    nome = fields.CharField(max_length=10)
    limite = fields.IntField()
    saldo = fields.IntField()
                       
    def __str__(self):
        return self.nome