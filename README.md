# README


## Configuracao inicial
```
$ bundle install
$ rails db:setup
```

## Subir o servidor

`$ rails s`

## Visao geral

Primeiro e necessario obter um token de autenticacao para gerenciar as contas do sistema.
Um usuario so consegue gerenciar as suas proprias contas.

Para obter um token, chame:

`$ curl -H "Content-Type: application/json" -X POST -d '{"email":"user@test.com","password":"123123"}' http://localhost:3000/authenticate`

O `<auth_token>` deve ir no header `Authorization: <auth_token>` em todas as chamadas subsequentes

### Criando uma conta

 - URL: `/checking_accounts`
 - Parametros de entrada: `id` (opcional), `name`, `amount`

```
{ 
  checking_account: { 
    id: id
    name: name, 
    amount: amount
  }
}
```

Exemplo

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X POST -d '{"checking_account":{"name": "Testing Accoun", "amount": "200.00"}}' http://localhost:3000/checking_accounts`

### Checando informacoes da conta

 - URL: `/checking_accounts<id>`

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X GET http://localhost:3000/checking_accounts/1`

### Operacoes na conta - Deposito, Saque e Transferencia

 - URL: `/transactions`
 - Parametros de entrada: `source_account_id`, `destination_account_id` e `amount`

Ao menos um dos ids de conta precisa ser nao-nulo e referente a uma conta existente.
So e possivel sacar da sua propria conta e fazer transferencias da sua propria conta.
Um erro ocorre se o saldo e insuficiente para saques ou transferencias.
O valor da transferencia e sempre positivo (um debito)

 - Exemplo - Retirar 20 reais da propria conta

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X POST -d '{"transaction":{"source_account_id":1,"amount":20}}' http://localhost:3000/transactions`

 - Exemplo - Depositar 20 reais da propria conta

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X POST -d '{"transaction":{"destination_account_id":1,"amount":20}}' http://localhost:3000/transactions`

 - Exemplo - Transferir 20 reais de uma conta para outra

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X POST -d '{"transaction":{"source_account_id":1,"destination_account_id","amount":20}}' http://localhost:3000/transactions`

## Testes

```
rails test
```
