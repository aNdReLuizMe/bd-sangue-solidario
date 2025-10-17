# Modelo de Dados - Sistema Sangue Solidário

## Visão Geral

Sistema de gestão e incentivo à doação de sangue para o Hemocentro Regional de Três Lagoas - MS.

---

## 1. Entidades Principais

### 1.1 DOADOR

**Descrição:** Armazena informações completas dos doadores cadastrados na plataforma.

**Atributos:**

- `id` (PK): Identificador único do doador
- `nome`: Nome completo do doador
- `cpf` (UK): CPF único do doador
- `email` (UK): E-mail único para login e notificações
- `telefone`: Telefone para contato
- `data_nascimento`: Data de nascimento
- `genero`: Gênero (Masculino, Feminino, Outro)
- `tipo_sanguineo`: Tipo sanguíneo (A, B, AB, O)
- `fator_rh`: Fator RH (Positivo, Negativo)
- `elegivel`: Indica se está apto para doar
- `contador_doacoes`: Total de doações realizadas
- `ultima_doacao`: Data da última doação
- `proxima_doacao_permitida`: Data calculada automaticamente
- `senha_hash`: Senha criptografada
- `endereco_id` (FK): Referência ao endereço

**Restrições:**

- CPF deve ser válido e único
- E-mail deve ser válido e único
- Idade mínima: 18 anos, máxima: 69 anos (1ª doação até 60 anos)
- Intervalo entre doações: 60 dias para homens, 90 dias para mulheres
- Máximo de doações por ano: 4 para homens, 3 para mulheres

**Índices:**

- PRIMARY KEY (id)
- UNIQUE INDEX (cpf)
- UNIQUE INDEX (email)
- INDEX (tipo_sanguineo, fator_rh)
- INDEX (proxima_doacao_permitida)

---

### 1.2 ENDERECO

**Descrição:** Armazena endereços dos doadores.

**Atributos:**

- `id` (PK): Identificador único
- `cep`: Código postal
- `logradouro`: Rua/Avenida
- `numero`: Número do imóvel
- `complemento`: Complemento (opcional)
- `bairro`: Bairro
- `cidade`: Cidade
- `estado`: Sigla do estado (UF)

**Restrições:**

- CEP deve ter 8 dígitos
- Estado deve ser sigla válida (2 caracteres)

---

### 1.3 AGENDAMENTO

**Descrição:** Gerencia os agendamentos de doações.

**Atributos:**

- `id` (PK): Identificador único
- `doador_id` (FK): Referência ao doador
- `local_doacao_id` (FK): Local onde será realizada
- `campanha_id` (FK): Campanha associada (opcional)
- `data_agendamento`: Data da doação
- `horario`: Horário da doação
- `status`: Status do agendamento
- `tipo_doacao`: Tipo de doação (Sangue Total, Plaquetas, etc.)
- `compareceu`: Se o doador compareceu
- `observacoes`: Observações adicionais

**Status possíveis:**

- `pendente`: Aguardando confirmação
- `confirmado`: Confirmado pelo sistema
- `realizado`: Doação realizada
- `cancelado`: Cancelado pelo doador
- `faltou`: Doador não compareceu

**Restrições:**

- Não pode agendar se doador não estiver elegível
- Data deve ser futura
- Horário deve estar dentro do funcionamento do local
- Máximo de 1 agendamento ativo por doador
- Não pode ter mais de um agendamento no mesmo horário e local

**Índices:**

- PRIMARY KEY (id)
- INDEX (doador_id)
- INDEX (data_agendamento, horario)
- INDEX (status)

---

### 1.4 LOCAL_DOACAO

**Descrição:** Locais onde as doações podem ser realizadas.

**Atributos:**

- `id` (PK): Identificador único
- `nome`: Nome do local
- `endereco_completo`: Endereço completo
- `telefone`: Telefone de contato
- `horario_funcionamento`: Horários de funcionamento
- `capacidade_diaria`: Número máximo de doações por dia
- `ativo`: Se o local está ativo

**Restrições:**

- Capacidade diária deve ser maior que 0
- Horário de funcionamento deve ser válido

---

### 1.5 HISTORICO_DOACOES

**Descrição:** Registro histórico de todas as doações realizadas.

**Atributos:**

- `id` (PK): Identificador único
- `doador_id` (FK): Doador que realizou
- `data_doacao`: Data da doação
- `local_doacao`: Nome do local
- `tipo_doacao`: Tipo de doação realizada
- `volume_ml`: Volume doado em mililitros
- `observacoes_medicas`: Observações médicas
- `reacao_adversa`: Se houve reação adversa

**Restrições:**

- Data da doação não pode ser futura
- Volume deve estar entre 300ml e 500ml (para sangue total)
- Registro é imutável após criação

**Índices:**

- PRIMARY KEY (id)
- INDEX (doador_id)
- INDEX (data_doacao)

---

### 1.6 CAMPANHA

**Descrição:** Campanhas específicas de doação.

**Atributos:**

- `id` (PK): Identificador único
- `titulo`: Título da campanha
- `descricao`: Descrição detalhada
- `data_inicio`: Data de início
- `data_fim`: Data de término
- `tipo_sanguineo_alvo`: Tipo sanguíneo específico (opcional)
- `status`: Status da campanha
- `meta_doacoes`: Meta de doações
- `doacoes_realizadas`: Doações já realizadas
- `administrador_id` (FK): Administrador responsável

**Status possíveis:**

- `planejada`: Ainda não iniciou
- `ativa`: Em andamento
- `concluida`: Finalizada
- `cancelada`: Cancelada

**Restrições:**

- Data fim deve ser posterior à data início
- Meta de doações deve ser maior que 0
- Doações realizadas não pode exceder a meta

**Índices:**

- PRIMARY KEY (id)
- INDEX (status)
- INDEX (data_inicio, data_fim)

---

### 1.7 ESTOQUE_SANGUE

**Descrição:** Controle de estoque de bolsas de sangue.

**Atributos:**

- `id` (PK): Identificador único
- `hemocentro_id` (FK): Hemocentro responsável
- `tipo_sanguineo`: Tipo sanguíneo
- `fator_rh`: Fator RH
- `quantidade_bolsas`: Quantidade disponível
- `nivel_estoque`: Nível crítico/adequado
- `data_validade_proxima`: Próxima bolsa a vencer
- `ultima_atualizacao`: Última atualização do estoque

**Níveis de estoque:**

- `critico`: < 10 bolsas
- `baixo`: 10-30 bolsas
- `adequado`: 31-100 bolsas
- `excelente`: > 100 bolsas

**Restrições:**

- Quantidade não pode ser negativa
- Tipo sanguíneo + Fator RH devem ser únicos por hemocentro
- Nível é calculado automaticamente baseado na quantidade

**Índices:**

- PRIMARY KEY (id)
- UNIQUE INDEX (hemocentro_id, tipo_sanguineo, fator_rh)
- INDEX (nivel_estoque)

---

### 1.8 HEMOCENTRO

**Descrição:** Hemocentros cadastrados no sistema.

**Atributos:**

- `id` (PK): Identificador único
- `nome`: Nome do hemocentro
- `cnpj` (UK): CNPJ único
- `endereco_completo`: Endereço completo
- `telefone`: Telefone de contato
- `email`: E-mail institucional
- `responsavel_tecnico`: Nome do responsável
- `ativo`: Se está ativo no sistema

**Restrições:**

- CNPJ deve ser válido e único
- E-mail deve ser válido

---

### 1.9 NOTIFICACAO

**Descrição:** Sistema de notificações para doadores.

**Atributos:**

- `id` (PK): Identificador único
- `doador_id` (FK): Doador destinatário
- `administrador_id` (FK): Administrador que enviou
- `tipo`: Tipo de notificação
- `titulo`: Título da notificação
- `mensagem`: Conteúdo da mensagem
- `canal`: Canal de envio
- `enviada`: Se foi enviada
- `lida`: Se foi lida pelo doador
- `data_envio`: Data/hora do envio
- `data_leitura`: Data/hora da leitura

**Tipos de notificação:**

- `lembrete_doacao`: Lembrete para doar novamente
- `campanha`: Notificação de campanha
- `estoque_critico`: Alerta de estoque crítico
- `confirmacao_agendamento`: Confirmação de agendamento
- `cancelamento`: Notificação de cancelamento

**Canais:**

- `email`: E-mail
- `sms`: SMS
- `push`: Notificação push
- `sistema`: Notificação in-app

**Índices:**

- PRIMARY KEY (id)
- INDEX (doador_id, lida)
- INDEX (data_envio)

---

### 1.10 ADMINISTRADOR

**Descrição:** Usuários administrativos do sistema.

**Atributos:**

- `id` (PK): Identificador único
- `nome`: Nome completo
- `email` (UK): E-mail único para login
- `senha_hash`: Senha criptografada
- `cargo`: Cargo/função
- `nivel_acesso`: Nível de permissões
- `hemocentro_id` (FK): Hemocentro vinculado
- `ativo`: Se está ativo
- `ultimo_acesso`: Data do último acesso

**Níveis de acesso:**

- `super_admin`: Acesso total ao sistema
- `admin`: Administrador do hemocentro
- `coordenador`: Coordenador de campanhas
- `operador`: Operador básico

**Restrições:**

- E-mail deve ser único e válido
- Deve estar vinculado a um hemocentro ativo

---

### 1.11 RELATORIO

**Descrição:** Relatórios gerados pelo sistema.

**Atributos:**

- `id` (PK): Identificador único
- `administrador_id` (FK): Quem gerou
- `tipo_relatorio`: Tipo de relatório
- `periodo_inicio`: Início do período
- `periodo_fim`: Fim do período
- `dados_relatorio`: Dados em JSON
- `formato_arquivo`: Formato exportado
- `data_geracao`: Data/hora da geração

**Tipos de relatório:**

- `doacoes_periodo`: Doações em período
- `doadores_ativos`: Doadores ativos
- `campanhas`: Relatório de campanhas
- `estoque`: Relatório de estoque
- `agendamentos`: Relatório de agendamentos

---

## 2. Relacionamentos

### 2.1 DOADOR → ENDERECO (1:1)

- Um doador tem um endereço
- Cascata: Ao excluir doador, exclui endereço

### 2.2 DOADOR → AGENDAMENTO (1:N)

- Um doador pode ter vários agendamentos
- Um agendamento pertence a um doador

### 2.3 DOADOR → HISTORICO_DOACOES (1:N)

- Um doador pode ter várias doações no histórico
- Cada registro de doação pertence a um doador

### 2.4 DOADOR → NOTIFICACAO (1:N)

- Um doador pode receber várias notificações
- Cada notificação é destinada a um doador

### 2.5 AGENDAMENTO → LOCAL_DOACAO (N:1)

- Vários agendamentos podem ocorrer no mesmo local
- Cada agendamento tem um local específico

### 2.6 CAMPANHA → AGENDAMENTO (1:N)

- Uma campanha pode ter vários agendamentos
- Um agendamento pode estar vinculado a uma campanha (opcional)

### 2.7 ADMINISTRADOR → CAMPANHA (1:N)

- Um administrador pode gerenciar várias campanhas
- Cada campanha tem um administrador responsável

### 2.8 HEMOCENTRO → ESTOQUE_SANGUE (1:N)

- Um hemocentro possui vários estoques (um por tipo sanguíneo)
- Cada estoque pertence a um hemocentro

### 2.9 ADMINISTRADOR → NOTIFICACAO (1:N)

- Um administrador pode enviar várias notificações
- Cada notificação é enviada por um administrador

### 2.10 ADMINISTRADOR → HEMOCENTRO (N:1)

- Vários administradores podem trabalhar em um hemocentro
- Cada administrador está vinculado a um hemocentro

### 2.11 ADMINISTRADOR → RELATORIO (1:N)

- Um administrador pode gerar vários relatórios
- Cada relatório é gerado por um administrador

---

## 3. Regras de Negócio

### 3.1 Elegibilidade para Doação

1. Idade: entre 18 e 69 anos (primeira doação até 60 anos)
2. Peso: mínimo 50kg
3. Intervalo entre doações:
   - Homens: 60 dias (máximo 4 doações/ano)
   - Mulheres: 90 dias (máximo 3 doações/ano)
4. Não pode estar doente ou ter viajado para área de risco
5. Jejum mínimo de 4 horas

### 3.2 Cálculo Automático

- `proxima_doacao_permitida` = `ultima_doacao` + intervalo (60/90 dias)
- `nivel_estoque` calculado automaticamente baseado em quantidade
- `elegivel` atualizado automaticamente após cada doação

### 3.3 Notificações Automáticas

- Enviar notificação quando doador estiver elegível novamente
- Alertar quando estoque estiver crítico
- Confirmar agendamentos 24h antes
- Notificar sobre campanhas específicas para tipo sanguíneo

### 3.4 Segurança e Privacidade (LGPD)

- Senhas criptografadas com bcrypt
- Dados pessoais sensíveis protegidos
- Consentimento explícito para comunicações
- Direito ao esquecimento (exclusão de dados)
- Logs de acesso a dados sensíveis

### 3.5 Validações de Sistema

- Não permitir mais de 1 agendamento ativo por doador
- Verificar capacidade do local antes de agendar
- Validar horário de funcionamento do local
- Impedir agendamento se doador não elegível
- Atualizar contador e histórico após doação

---

## 4. Triggers e Procedimentos Sugeridos

### 4.1 Triggers

```sql
-- Atualizar próxima doação permitida após doação
TRIGGER after_donation_update

-- Atualizar nível de estoque após mudança de quantidade
TRIGGER update_stock_level

-- Enviar notificação automática quando elegível
TRIGGER notify_eligible_donor

-- Atualizar contador de doações
TRIGGER update_donation_counter

-- Verificar capacidade antes de agendar
TRIGGER check_location_capacity
```

### 4.2 Stored Procedures

```sql
-- Calcular elegibilidade do doador
PROCEDURE check_donor_eligibility(doador_id)

-- Gerar relatório de doações
PROCEDURE generate_donation_report(start_date, end_date)

-- Enviar notificações em lote
PROCEDURE send_batch_notifications(campaign_id)

-- Atualizar estoque após doação
PROCEDURE update_blood_stock(donation_id)
```

---

## 5. Índices e Performance

### 5.1 Índices Críticos

- Doadores por tipo sanguíneo e elegibilidade
- Agendamentos por data e status
- Notificações não lidas por doador
- Estoque por nível crítico
- Histórico de doações por doador e período

### 5.2 Otimizações

- Particionamento de histórico por ano
- Cache de consultas frequentes
- Índices compostos para queries comuns
- Arquivo de auditoria separado

---

## 6. Segurança

### 6.1 Controle de Acesso

- Autenticação obrigatória para todas as operações
- Níveis de permissão por tipo de usuário
- Logs de todas as operações sensíveis
- Sessões com timeout automático

### 6.2 Proteção de Dados

- Criptografia de senhas (bcrypt)
- Criptografia de dados sensíveis em repouso
- HTTPS obrigatório para transmissão
- Backup automático diário
- Retenção de dados por 5 anos

---

## 7. Conformidade LGPD

### 7.1 Dados Sensíveis

- Tipo sanguíneo
- Histórico médico
- Dados de saúde

### 7.2 Direitos do Titular

- Consentimento explícito
- Acesso aos dados
- Correção de dados
- Exclusão de dados (esquecimento)
- Portabilidade de dados

### 7.3 Logs e Auditoria

- Registro de todos os acessos
- Quem acessou, quando e quais dados
- Retenção de logs por 6 meses
