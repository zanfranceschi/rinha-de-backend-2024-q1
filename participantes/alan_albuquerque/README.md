![so_o_basico](./so_o_basico.png)

#  Dotnet só o básico.

[repo](https://github.com/offpepe/rinha-2024-q1) - [twitter](https://twitter.com/Offplayer_G)

Submissão só o básico, .NET 8 nativo, multiplexin e reza braba, com muita fé eu vo longe🙏

- .NET 8 AOT
- Postgresql
- nginx
- Fé



## Pontos importantes

1. Reduzi o numero de iterações com o banco, ao consultar clientes e transações busco tudo na mesma consulta (não transformei em json, onera muito);
2. Cada tipo de transação tem uma ``storage procedure``, onde o resultado é atribuido a um ``out parameter``;
3. Evito ao máximo tipos de referência;
4. Sem fluxo alternativo por erro, cada caso tem uma resposta que pode ser interpretado de determinada maneira, sem necessidade de capturar diferentes tipos de exceções;
5. Eu torço para o Vasco da Gama, então eu tenho muita fé.
