# README


## Configuração inicial
```
$ bundle install
$ rails db:setup
```

## Subir o servidor

`$ rails s`

## Visão geral

Primeiro é necessario obter um token de autenticação para gerenciar as contas do sistema.
Um usuário só consegue gerenciar as suas proprias contas.

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

### Checando informaçoes da conta

 - URL: `/checking_accounts<id>`

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X GET http://localhost:3000/checking_accounts/1`

### Operaçoes na conta - Deposito, Saque e Transferencia

 - URL: `/transactions`
 - Parametros de entrada: `source_account_id`, `destination_account_id` e `amount`

Ao menos um dos ids de conta (`source_account_id`, `destination_account_id`) precisa ser não-nulo e, no caso, referente a uma conta existente.
Só é possivel sacar da sua propria conta e fazer transferências da sua propria conta.
Um erro ocorre se o saldo é insuficiente para saques ou transferências.
O valor da (`amount`) da transferência é sempre positivo

 - Exemplo - Retirar 20 reais da própria conta

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X POST -d '{"transaction":{"source_account_id":1,"amount":20}}' http://localhost:3000/transactions`

 - Exemplo - Depositar 20 reais da própria conta

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X POST -d '{"transaction":{"destination_account_id":1,"amount":20}}' http://localhost:3000/transactions`

 - Exemplo - Transferir 20 reais de uma conta para outra

`$ curl -H "Content-Type: application/json" -H "Authorization: <auth_token>" -X POST -d '{"transaction":{"source_account_id":1,"destination_account_id","amount":20}}' http://localhost:3000/transactions`

## Testes

```
rails test
```

## GEMS usadas

 - `simple_command`, `jwt`, `bcrypt`

 Gems usadas para autenticação. Sistema de autenticação inspirado por https://www.pluralsight.com/guides/token-based-authentication-with-ruby-on-rails-5-api

  - `active_model_serializers`

  Gem usada para facilitar a serialização do saldo da conta
