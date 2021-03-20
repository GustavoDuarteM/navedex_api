# Navedex Api
 Um navedex's pra gerenciar sers navers e projetos. 

### 🛠️ Stack 
 - Docker v20.10.5
 - Ruby v3.0.0
 - Ruby one Rails v6.1.3
 - Postgres v13.2
 - Redis v6.2.1

### 💎 Gems
 - jwt_sessions
 - jsonapi-serializer
 - bcrypt
 - rspec-rails
 - factory_bot_rails
 

### ⚙️ Configurações 
Para rodar o projeto você vai precisar ter instalado o docker

### 🚀 Inicializando o projeto 
1º Clone o repositório

2º Acesse a pasta do projeto no terminal e rode os seguintes comandos
```
  docker-compose build
  docker-compose up -d
  docker-compose exec app rails db:create db:migrate
```
✨ O projeto está rodando e pode ser acessado http://localhost:3000/

### ⚡Como testar 

#### Rotas 
Arquivo exportado do insominia. Aqui os campos de cada rota está documentado

[Insomnia_navedex_api.zip](https://github.com/GustavoDuarteM/navedex_api/files/6176219/Insomnia_navedex_api.zip)

##### Para fazer Autenticação
As rotas de acesso irão retornar uma chave JWT que será necessários para acessar as outras rotas

 - Novo Cadastro `/sign_up`
 - Acessar `/login`
  
##### Para acessar Navers e Projects
⚠️ As rotas exigem autenticação ⚠️

Usando o token gerado na autenticação ele deve ser usado como parâmetro no header da requisição
Com o insomnia você deve inserir essa chave no campo `token` que está acessível no seguinte menu `Auth/Bearer Token`

|        |     Navers    |     Projects    |
|--------|:-------------:|:---------------:|
| Index  | /naver/index  | /project/index  |
| Store  | /naver/store  | /project/store  |
| Show   | /naver/show   | /project/show   |
| Update | /naver/update | /project/update |
| Delete | /naver/delete | /project/delete |
