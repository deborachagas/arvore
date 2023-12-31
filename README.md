<details>
  <summary>Case Técnico Árvore</summary>

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

</details>
<details>
  <summary>Rodar o projeto usando o docker</summary>

* Pré-requisitos:

  * Instalar [docker](https://docs.docker.com/engine/install/)

* Clonar o projeto

```
git clone https://github.com/deborachagas/arvore.git
```

* Acessar a pasta do projeto:

```
cd arvore
```

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

</details>
<details>
  <summary>Rodar o projeto localmente</summary>

* Pré-requisitos:

  * Instalar [erlang](https://github.com/asdf-vm/asdf-erlang);
  * Instalar [elixir](https://github.com/asdf-vm/asdf-elixir);
  * Instalar [postgres](https://www.postgresql.org/download/);

* Clonar o projeto

```
git clone https://github.com/deborachagas/arvore.git
```

* Acessar a pasta do projeto:

```
cd arvore
```

* Instalar as dependências: 

```
mix deps.get
```

* Configurar o banco de dados com as informaçõe do banco no arquivo dev.ex:

```
config :arvore, Arvore.Repo,
  username: "root",
  password: "mysql",
  database: "arvore_dev",
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

* Para verificar se está tudo funcionando corretamente, após o servidor terminar de iniciar, 
basta ir até o navegador e acessar a página:


[http://localhost:4000/health](http://localhost:4000/health)

</details>
<details>
  <summary>Acesso API</summary>
  
- URL - [https://teste-debora-arvore.fly.dev](https://teste-debora-arvore.fly.dev)
- Criar um usuário, para isso não é necessário estar autenticado - [link](https://teste-debora-arvore.fly.dev/api/swagger/index.html#/User/ArvoreWeb_V1_Accounts_UserController_create)
- Logar na api com o usuário criado - [link](https://teste-debora-arvore.fly.dev/api/swagger/index.html#/Authentication/ArvoreWeb_V1_Accounts_AuthenticationController_login)
- Passar o jwt gerado no header Authorization "Bearer Token"

</details>
<details>
  <summary>Documentação da API</summary>

Documentação da api gerado com o plug phoenix_swagger:
[https://teste-debora-arvore.fly.dev/api/swagger](https://teste-debora-arvore.fly.dev/api/swagger)

</details>
<details>
  <summary>API Graphiql exemplo</summary>

* Usar o token gerado pelo endpoint de login no header Authorization "Bearer Token"
* POST: https://teste-debora-arvore.fly.dev/graphiql

### Queries:

* Listar todos as entidades

```
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
```

* Retornar uma entidade pelo id

```
query entity($id: ID!){
  findEntity(id: $id) {
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
```

* Criar uma entidade


```
mutation createEntity{
  createEntity(
      name: "new entity network",
      entityType: "network"
  ) {
    id
    name
    inep
    entityType
    parentId
  }
}
```

* Atualizar uma entidade


```
mutation updateEntity($id: ID!){
  updateEntity(
      id: $id,
      name: "update entity network",
      inep: "inep",
      entityType: "school"
  ) {
    id
    name
    inep
    entityType
    parentId
  }
}
```

* Deletar uma entidade

```
mutation deleteEntity($id: ID!){
    deleteEntity(id: $id) {
        id
        name
        inep
        entityType
        parentId
    }
}
```

</details>
<details>
  <summary>Tecnologias utilizadas</summary>

  - Docker para rodar container do banco de dados mysql e do elixir
  - Testes Automatizados, validação da cobertura de código com o plug excoveralls - [TOTAL]  96.4%
  - Testes E2E utilizando o Postman
  - Testes de carga utilizando o k6
  - Validação da estrutura do código com o plug credo
  - Github CI para integração contínua
    - Faz o build da aplicação
    - Faz os testes automatizados
    - Caso de certo realiza o deploy da aplicação no fly.io, se não passar, não faz o deploy
    - Depois de finalizar o deploy:
      - Faz os testes E2E
      - Faz os testes de carga
  - Autenticação da API
    - Criptografia da senha do usuário com o plug bcrypt_elixir
    - Autorização da API com token JWT utilizando um plug na rota
    - Autenticação do jwt utilizando o plug joken
  - Implementação de graphiql utilizando plug absinthe
</details>