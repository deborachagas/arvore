# Case Técnico Árvore

## Objetivo:

Construir uma API usando Phoenix (elixir) e banco de dados MySQL visando permitir a um parceiro da Árvore replicar a sua estrutura de Redes, Escolas, Turmas e administrá-la conforme necessário. O acesso a esta API deve ser restrita com um mecanismo de autenticação usando uma ou mais chaves de acesso, às quais devem estar vinculadas ao parceiro.

A modelagem deverá utilizar apenas uma entidade (Entity), que poderá representar qualquer nível da estrutura hierárquica.

### Tipos:

As entidades serão identificadas pelos seguintes tipos:

- Network - é o mais alto nível permitido para criação de entidades, representando uma rede de escolas - Não é um nível obrigatório;
- School - representa uma escola, podendo ou não estar relacionada a uma rede;
- Class - representa uma turma e deve obrigatoriamente ser relacionado a uma escola.

### Atributos:

- name: nome;
- entity_type: tipo da entidade;
- inep: código INEP, usado apenas para entity_type com valor school.
- parent_id: identificador da entidade antecessora na hierarquia.

A entidade mais alta da hierarquia (network ou school), terá parent_id nulo.

## Alguns exemplos de requisições e retornos esperados seguem a seguir.

### Criação de uma entidade:

No exemplo abaixo uma escola sem um antecessor hierárquico está sendo criado.

* Request:

```
POST /api/v2/partners/entities
Headers:
Content-Type:application/json
Body:
{
  "name": "Escola Exemplo",
  "entity_type": "school",
  "inep": "123456",
  "parent_id": null
}
```

* Response:

```
Headers:
Content-Type:application/json; charset=utf-8
Body:
{
  "data": {
    "id": 2,
    "entity_type": "school",
    "inep": "123456",
    "name": "Escola Exemplo",
    "parent_id": null,
    "subtree_ids": []
  }
}
```

A chave subtree_ids deverá trazer uma lista com os IDs de todas as entidades relacionadas à entidade retornada.

### Exibição de uma entidade:

* Request

```
GET /api/v2/partners/entities/id-da-entidade
Headers:
Content-Type:application/json
Parameters:
id: integer - ex: 2
```

* Response

```
Headers:
Content-Type:application/json; charset=utf-8
Body:
{
  "data": {
    "id": 2,
    "entity_type": "school",
    "inep": "123456",
    "name": "Escola Exemplo",
    "parent_id": null,
    "subtree_ids": [3, 4]
  }
}
```

### Edição de uma entidade:

* Request:

```
PUT /api/v2/partners/entities/id-da-entidade
Headers:
Content-Type:application/json
Parameters:
id: integer - ex: 2
Body:
{
  "name": "Escola Exemplo",
  "entity_type": "school",
  "inep": "789123",
  "parent_id": null
}
```

* Response:

```
Headers:
Content-Type:application/json; charset=utf-8
Body:
{
  "data": {
    "id": 2,
    "entity_type": "school",
    "inep": "789123",
    "name": "Escola Exemplo",
    "parent_id": null,
    "subtree_ids": [3, 4]
  }
}
```

## Requisitos mínimos:

- Documentação do repositório git
- Deploy em qualquer serviço para consumo durante avaliação
- Testes E2E
- Integração contínua (CI)

## Requisitos desejáveis:

- GraphQL (schema pode refletir a mesma estrutura acima)
- Testes de carga
# Configurar o projeto

* Clonar o projeto

```
git clone https://github.com/deborachagas/arvore.git
```

* Acessar a pasta do projeto:

```
cd arvore
```

## Rodar o projeto usando o docker:

* Pré-requisitos:

  * Instalar [docker](https://docs.docker.com/engine/install/)

* Execute a imagem do Dockerfile:

```
docker-compose build
``` 

* Inicializar o banco de dados com o Ecto:

```
docker-compose run --rm phoenix mix ecto.create
```

* Iniciar o ambiente:

```
docker-compose up -d
```

* Para verificar se está tudo funcionando corretamente, após o servidor terminar de iniciar, 
basta ir até o navegador e acessar a página:

```
http://localhost:4000/health
```

## Rodar o projeto localmente:

* Pré-requisitos:

  * Instalar [erlang](https://github.com/asdf-vm/asdf-erlang);
  * Instalar [elixir](https://github.com/asdf-vm/asdf-elixir);
  * Instalar [postgres](https://www.postgresql.org/download/);

* Instalar as dependências: 

```
mix deps.get
```

* Configurar o banco de dados com as informaçõe do banco no arquivo dev.ex:

```
config :arvore, Arvore.Repo,
  username: "root",
  password: "mysql",
  database: "arvore_prod",
  hostname: "db_mysql",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

* Criar e atualizar o banco de dados: 

```
mix ecto.setup
```

* Iniciar o servidor Phoenix: 

```
mix phx.server
```

* * Para verificar se está tudo funcionando corretamente, após o servidor terminar de iniciar, 
basta ir até o navegador e acessar a página:


[http://localhost:4000/health](http://localhost:4000/health)


# Funcionamento

## Endereço API:

[https://teste-debora-arvore.fly.dev/health](https://teste-debora-arvore.fly.dev/health)

## Cadastrar um usuário

```
POST:https://teste-debora-arvore.fly.dev/api/v1/accounts/users
Body:
{
    "name": "name",
    "login": "login",
    "password": "password",
    "type": "admin",
    "email": "email@email.com"
}
Response:
{
  "data": {
      "email": "email@email.com",
      "id": 1,
      "login": "login",
      "name": "name",
      "type": "admin"
    }
}
```

## Login

```
POST:https://teste-debora-arvore.fly.dev/api/v1/accounts/login
Headers:
  { Content-Type: application/json }
Body:
  {
      "login": "login",
      "password": "password"
  }
Response:
  {
    "data":
      {
        "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6Ikp...rMy7OsEW0m6lByqs83I42q8XaY4yreNNQO0oQje8"
      }
  }
```

## Acesso API com autenticação exemplo

Usar o token gerado pelo endpoint de login

```
GET: https://teste-debora-arvore.fly.dev/api/v2/partners/entities/:id_entity
  Headers:
  {
    Content-Type: application/json
    Authorization: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6Ikp...rMy7OsEW0m6lByqs83I42q8XaY4yreNNQO0oQje8"
  }

Response:
  {
    "data": {
      "id": 2,
      "entity_type": "school",
      "inep": "123456",
      "name": "Escola Exemplo",
      "parent_id": null,
      "subtree_ids": [3, 4]
    }
  }
```

## Acesso API graphiql exemplo

Usar o token gerado pelo endpoint de login

```
GET: https://teste-debora-arvore.fly.dev/graphiql
  Headers:
  {
    Content-Type: application/json
    Authorization: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6Ikp...rMy7OsEW0m6lByqs83I42q8XaY4yreNNQO0oQje8"
  }

  Query:
  {
    allEntities {
      id
      name
      inep
      entityType
      parent {
          id
          name
      }
      subtree {
          id
          name
      }
    }
  }

  Response:
  "data": {
    "allEntities": [
      {
        "entityType": "network",
        "id": "1",
        "inep": null,
        "name": "Networ01",
        "parent": null,
        "subtree": [
          {
              "id": "3",
              "name": "School01"
          },
          {
              "id": "4",
              "name": "School02"
          }
        ]
      }
    ]
  }
```

# Desenvolvimento

- Docker para rodar container do banco de dados mysql e do elixir
- Testes Automatizados
- Testes E2E utilizando o Postman
- Validação da cobertura de código com o plug excoveralls

----------------
COV    FILE                                                            LINES RELEVANT   MISSED
 94.1% lib/arvore/accounts.ex                                            183       17        1
100.0% lib/arvore/accounts/arvore_token.ex                                27        6        0
100.0% lib/arvore/accounts/user.ex                                        53        6        0
 91.7% lib/arvore/partners.ex                                            131       12        1
100.0% lib/arvore/partners/entity.ex                                     124       22        0
 71.4% lib/arvore_web/controllers/fallback_controller.ex                  37        7        2
100.0% lib/arvore_web/controllers/health_check_controller.ex               7        1        0
100.0% lib/arvore_web/controllers/v1/accounts/authentication_contro       20        5        0
 81.3% lib/arvore_web/controllers/v1/accounts/user_controller.ex          63       16        3
100.0% lib/arvore_web/controllers/v2/partners/entity_controller.ex        52       13        0
 90.9% lib/arvore_web/plugs/jwt_auth_plug.ex                              43       11        1
  0.0% lib/arvore_web/schema.ex                                           34        0        0
  0.0% lib/arvore_web/schema/entity_types.ex                              16        0        0
100.0% lib/arvore_web/views/changeset_view.ex                             13        2        0
100.0% lib/arvore_web/views/error_view.ex                                 20        2        0
100.0% lib/arvore_web/views/v1/accounts/user_view.ex                      21        8        0
100.0% lib/arvore_web/views/v2/partners/entity_view.ex                    25       11        0
[TOTAL]  94.2%
----------------

- Validação da estrutura do código com o plug credo
- Github CI para integração contínua
  - Faz o build da aplicação
  - Faz os testes automatizados
  - Faz os testes E2E
  - Caso de tudo certo realiza o deploy da aplicação no fly.io, se não passar, não faz o deploy

- Autenticação da API
  - Criptografia da senha do usuário com o plug bcrypt_elixir
  - Autorização da API com token JWT utilizando um plug na rota
  - Autenticação do jwt utilizando o plug joken

- Implementação de graphiql utilizando plug absinthe