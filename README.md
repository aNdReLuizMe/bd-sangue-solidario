## Sangue Solidário — Banco de Dados e Execução

Projeto de banco de dados para o sistema Sangue Solidário, com ambiente Docker para MySQL 8.0, scripts de criação/população e consultas de manipulação de dados.

### Obtenção do código

Clone o repositório:

```bash
git clone https://github.com/aNdReLuizMe/bd-sangue-solidario
cd bd-sangue-solidario
```

Repositório: [aNdReLuizMe/bd-sangue-solidario](https://github.com/aNdReLuizMe/bd-sangue-solidario)

### Requisitos

- Docker e Docker Compose instalados

### Subir o ambiente

Na raiz do projeto:

```bash
docker compose up -d
```

Isso irá:

- Subir um container `mysql:8.0` com nome `sangue_solidario_db`
- Criar o banco `sangue_solidario`
- Executar automaticamente os scripts em `init-db/` (apenas na inicialização de um volume vazio)

Credenciais (definidas em `compose.yml`):

- Host: `localhost`
- Porta: `3306`
- Database: `sangue_solidario`
- Usuário: `user`
- Senha: `123`
- Root: `root` / `root123`

### Estrutura de diretórios

- `compose.yml`: definição do serviço MySQL e volume
- `init-db/01-schema-db.sql`: criação do schema (tabelas, índices, FKs, constraints)
- `init-db/02-data-database.sql`: carga inicial (seeds) das tabelas
- `sql/03-manipulate-data.sql`: exemplos de inserção/atualização/remoção e consultas
- `docs/diagram-er.md`: documentação do modelo de dados e regras de negócio
- `docs/bd-sangue-solidario-ER.mdj`: fonte do diagrama ER (StarUML)
- `docs/bd-sangue-solidario-ER.png`: renderização do diagrama ER

### Como os scripts são executados

O MySQL oficial executa todos os arquivos `.sql` presentes no diretório montado em `/docker-entrypoint-initdb.d` somente quando o volume de dados está vazio (primeiro start do container/volume).

Neste projeto, o diretório `init-db/` é montado como init-directory (ver `compose.yml`):

- `init-db/01-schema-db.sql` cria o banco e as tabelas
- `init-db/02-data-database.sql` popula as tabelas com dados iniciais

Se você já inicializou o container antes, o MySQL não executará novamente esses scripts ao reiniciar. Veja a seção de troubleshooting para resetar o volume.

### Executar consultas/manipulações após o ambiente subir

Você pode usar o cliente MySQL local ou executar dentro do container.

- Via cliente local (substitua a senha se necessário):

```bash
mysql -h 127.0.0.1 -P 3306 -u user -p123 sangue_solidario
```

- Via container:

```bash
docker exec -it sangue_solidario_db mysql -u root -p"root123" sangue_solidario
```

Para executar o script de manipulação (`sql/03-manipulate-data.sql`):

```bash
docker exec -i sangue_solidario_db mysql -u root -p"root123" sangue_solidario < sql/03-manipulate-data.sql
```

### Troubleshooting

- Banco/tabelas criam, mas não popula:
  - O init do MySQL só roda com volume vazio. Para recriar tudo:

```bash
docker compose down -v
docker compose up -d --wait
```

- Ver logs do MySQL:

```bash
docker logs -f sangue_solidario_db
```

- Acessar o MySQL como root:

```bash
docker exec -it sangue_solidario_db mysql -u root -p"root123"
```

### Observações do modelo de dados

- O schema está em `init-db/01-schema-db.sql` e segue as entidades e regras descritas em `docs/diagram-er.md`
- Seeds consistentes com os tipos/ENUMs e constraints estão em `init-db/02-data-database.sql`

### Limpar/Resetar ambiente

```bash
docker compose down -v && docker compose up -d --wait
```
