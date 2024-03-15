# Resultados da Rinha de Backend - Segunda Edição

## Contrato

Os resultados/ranking dos participantes são baseados em um SLA (fictício, claro kkk) que funciona da seguinte maneira:

### 98% das Respostas Abaixo de 250ms

A API precisa responder às requisições abaixo de 250ms em 98% ou mais das requisições durante o teste. Por exemplo, se no teste houvesse 1000 requisições, em 980 delas a API deve responder abaixo de 250ms com um status code 200 ou 422 (para o caso de saldo insuficiente).

Se a API tiver uma porcentagem menor de sucesso do que o estabelecido, uma multa será cobrada. A fórmula da multa é a seguinte: `(98 - [porcentagem de sucesso]) * USD 1000,00`. Por exemplo, uma API que conseguiu responder apenas 95% das requisições abaixo do tempo de resposta estabelecido, irá gerar uma multa de **USD 3000,00** `((98 - 95) * 1000,00)`.


### Consistência de Saldo
Cada resposta do teste que detectar inconsistência no saldo do cliente (extrato e/ou limite ultrapassado), irá gerar uma multa de `[quantidade de inconsistências] * USD 803,01`. Por exemplo, se durante o teste forem detectadas 10 respostas contendo inconsistência no saldo, uma multa de **USD 8030,10** `(10 * 803,01)` será gerada.


### Valor a Ser Pago Pelo Fornecimento da API
A Rinha de Backend® Inc. pagará um valor de USD 100.000,00 para cada fornecedor de API, descontando as multas para possíveis compensações de SLA mencionadas anteriomente.

## Resultados

Abaixo está a tabela com os valores e fornecedores da API de Crébitos da segunda edição da Rinha de Backend.
 
