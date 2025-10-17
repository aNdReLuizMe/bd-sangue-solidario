-- Script de População do Banco de Dados
-- Sistema: Sangue Solidário
-- ============================================
USE sangue_solidario;

-- ENDERECOS
INSERT INTO endereco (cep, logradouro, numero, complemento, bairro, cidade, estado) VALUES
('79600000', 'Rua das Flores', '100', 'Apto 101', 'Centro', 'Três Lagoas', 'MS'),
('79600001', 'Avenida Brasil', '250', NULL, 'Jardim Alvorada', 'Três Lagoas', 'MS'),
('79600002', 'Rua Santos Dumont', '500', 'Casa', 'Vila Nova', 'Três Lagoas', 'MS'),
('79600003', 'Avenida Capitão Olinto', '1200', NULL, 'Centro', 'Três Lagoas', 'MS'),
('79600004', 'Rua Amazonas', '350', 'Bloco B', 'Jardim Paraíso', 'Três Lagoas', 'MS'),
('79600005', 'Avenida Rosário Congro', '800', NULL, 'Vila Piloto', 'Três Lagoas', 'MS'),
('79600006', 'Rua Teotônio Vilela', '150', 'Apto 202', 'Santos Dumont', 'Três Lagoas', 'MS'),
('79600007', 'Rua José Garcia Leal', '420', NULL, 'Colinos', 'Três Lagoas', 'MS'),
('79600008', 'Avenida Filinto Muller', '650', 'Casa 2', 'Centro', 'Três Lagoas', 'MS'),
('79600009', 'Rua Major Rego', '90', NULL, 'Vila Haro', 'Três Lagoas', 'MS'),
('79600010', 'Avenida Clodoaldo Garcia', '1500', NULL, 'Centro', 'Três Lagoas', 'MS');

-- DOADORES
INSERT INTO doador (nome, cpf, email, telefone, data_nascimento, genero, tipo_sanguineo, fator_rh, elegivel, contador_doacoes, ultima_doacao, proxima_doacao_permitida, senha_hash, endereco_id) VALUES
('João Silva Santos', '12345678901', 'joao.silva@email.com', '67999001234', '1990-05-15', 'Masculino', 'O', 'Positivo', TRUE, 8, '2024-12-15', '2025-02-13', '$2y$10$abcdefghijklmnopqrstuv', 1),
('Maria Oliveira Costa', '23456789012', 'maria.oliveira@email.com', '67999002345', '1988-08-22', 'Feminino', 'A', 'Positivo', TRUE, 5, '2024-11-20', '2025-02-18', '$2y$10$bcdefghijklmnopqrstuvw', 2),
('Pedro Henrique Souza', '34567890123', 'pedro.souza@email.com', '67999003456', '1995-03-10', 'Masculino', 'B', 'Negativo', TRUE, 3, '2025-01-05', '2025-03-06', '$2y$10$cdefghijklmnopqrstuvwx', 3),
('Ana Paula Ferreira', '45678901234', 'ana.ferreira@email.com', '67999004567', '1992-11-30', 'Feminino', 'AB', 'Positivo', TRUE, 4, '2024-12-01', '2025-03-01', '$2y$10$defghijklmnopqrstuvwxy', 4),
('Carlos Eduardo Lima', '56789012345', 'carlos.lima@email.com', '67999005678', '1985-07-18', 'Masculino', 'O', 'Negativo', TRUE, 12, '2024-12-20', '2025-02-18', '$2y$10$efghijklmnopqrstuvwxyz', 5),
('Juliana Mendes Alves', '67890123456', 'juliana.alves@email.com', '67999006789', '1998-02-28', 'Feminino', 'A', 'Negativo', TRUE, 2, '2024-10-15', '2025-01-13', '$2y$10$fghijklmnopqrstuvwxyza', 6),
('Roberto Carlos Dias', '78901234567', 'roberto.dias@email.com', '67999007890', '1991-09-05', 'Masculino', 'B', 'Positivo', TRUE, 6, '2025-01-10', '2025-03-11', '$2y$10$ghijklmnopqrstuvwxyzab', 7),
('Fernanda Santos Cruz', '89012345678', 'fernanda.cruz@email.com', '67999008901', '1994-12-12', 'Feminino', 'AB', 'Negativo', TRUE, 3, '2024-11-25', '2025-02-23', '$2y$10$hijklmnopqrstuvwxyzabc', 8),
('Lucas Martins Rocha', '90123456789', 'lucas.rocha@email.com', '67999009012', '1987-04-20', 'Masculino', 'O', 'Positivo', FALSE, 10, '2025-01-15', '2025-03-16', '$2y$10$ijklmnopqrstuvwxyzabcd', 9),
('Camila Rodrigues Pereira', '01234567890', 'camila.pereira@email.com', '67999000123', '1996-06-08', 'Feminino', 'A', 'Positivo', TRUE, 7, '2024-12-05', '2025-03-05', '$2y$10$jklmnopqrstuvwxyzabcde', 10);

-- HEMOCENTRO
INSERT INTO hemocentro (nome, cnpj, endereco_completo, telefone, email, responsavel_tecnico, ativo) VALUES
('Hemocentro Regional de Três Lagoas', '12345678000190', 'Avenida Clodoaldo Garcia, 1500 - Centro, Três Lagoas - MS', '6735211234', 'contato@hemotreslagoas.ms.gov.br', 'Dr. Fernando Almeida Silva', TRUE);

-- ADMINISTRADORES
INSERT INTO administrador (nome, email, senha_hash, cargo, nivel_acesso, hemocentro_id, ativo) VALUES
('Fernando Almeida Silva', 'fernando.silva@hemotl.ms.gov.br', '$2y$10$superadmin123456789', 'Diretor Técnico', 'super_admin', 1, TRUE),
('Mariana Costa Santos', 'mariana.santos@hemotl.ms.gov.br', '$2y$10$admin123456789abcdef', 'Coordenadora de Captação', 'admin', 1, TRUE),
('Ricardo Souza Oliveira', 'ricardo.oliveira@hemotl.ms.gov.br', '$2y$10$coordenador123456789', 'Coordenador de Campanhas', 'coordenador', 1, TRUE),
('Patricia Lima Ferreira', 'patricia.ferreira@hemotl.ms.gov.br', '$2y$10$operador123456789abc', 'Atendente', 'operador', 1, TRUE);

-- LOCAL_DOACAO
INSERT INTO local_doacao (nome, endereco_completo, telefone, horario_funcionamento, capacidade_diaria, ativo) VALUES
('Hemocentro Regional - Sede', 'Avenida Clodoaldo Garcia, 1500 - Centro, Três Lagoas - MS', '6735211234', 'Segunda a Sexta: 07h às 17h | Sábado: 07h às 12h', 80, TRUE),
('Posto de Coleta - Shopping', 'Avenida Ranulpho Marques Leal, 3838 - Centro, Três Lagoas - MS', '6735229876', 'Segunda a Sábado: 10h às 20h', 40, TRUE),
('Posto de Coleta - UFMS', 'Avenida Ranulpho Marques Leal, 3484 - Distrito Industrial, Três Lagoas - MS', '6735099000', 'Segunda a Sexta: 08h às 16h', 30, TRUE);

-- CAMPANHAS
INSERT INTO campanha (titulo, descricao, data_inicio, data_fim, tipo_sanguineo_alvo, status, meta_doacoes, doacoes_realizadas, administrador_id) VALUES
('Junho Vermelho 2025', 'Campanha nacional de conscientização sobre doação de sangue', '2025-06-01', '2025-06-30', 'Todos', 'planejada', 500, 0, 3),
('Doação Solidária - Natal 2024', 'Campanha especial de fim de ano', '2024-12-01', '2024-12-31', 'Todos', 'concluida', 300, 285, 3),
('Tipo O Negativo - Urgente', 'Estoque crítico de tipo O negativo', '2025-01-15', '2025-02-15', 'O', 'ativa', 100, 45, 2),
('Doadores de Primeira Vez', 'Incentivo para novos doadores', '2025-02-01', '2025-03-31', 'Todos', 'ativa', 200, 78, 3);

-- AGENDAMENTOS
INSERT INTO agendamento (doador_id, local_doacao_id, campanha_id, data_agendamento, horario, status, tipo_doacao, compareceu) VALUES
(1, 1, 3, '2025-02-18', '08:00:00', 'confirmado', 'Sangue Total', FALSE),
(2, 1, 4, '2025-02-20', '09:30:00', 'confirmado', 'Sangue Total', FALSE),
(3, 2, 3, '2025-02-22', '14:00:00', 'pendente', 'Sangue Total', FALSE),
(4, 1, 4, '2025-03-05', '10:00:00', 'confirmado', 'Sangue Total', FALSE),
(5, 3, NULL, '2025-02-25', '08:30:00', 'confirmado', 'Sangue Total', FALSE),
(6, 1, NULL, '2025-01-20', '11:00:00', 'realizado', 'Sangue Total', TRUE),
(7, 2, 3, '2025-03-15', '15:00:00', 'pendente', 'Sangue Total', FALSE),
(10, 1, 4, '2025-03-10', '09:00:00', 'confirmado', 'Sangue Total', FALSE);

-- HISTORICO_DOACOES
INSERT INTO historico_doacoes (doador_id, data_doacao, local_doacao, tipo_doacao, volume_ml, observacoes_medicas, reacao_adversa) VALUES
(1, '2024-12-15', 'Hemocentro Regional - Sede', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(2, '2024-11-20', 'Hemocentro Regional - Sede', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(3, '2025-01-05', 'Posto de Coleta - Shopping', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(4, '2024-12-01', 'Hemocentro Regional - Sede', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(5, '2024-12-20', 'Hemocentro Regional - Sede', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(6, '2024-10-15', 'Posto de Coleta - UFMS', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(6, '2025-01-20', 'Hemocentro Regional - Sede', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(7, '2025-01-10', 'Posto de Coleta - Shopping', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(8, '2024-11-25', 'Hemocentro Regional - Sede', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE),
(9, '2025-01-15', 'Hemocentro Regional - Sede', 'Sangue Total', 450, 'Leve tontura após doação', TRUE),
(10, '2024-12-05', 'Posto de Coleta - Shopping', 'Sangue Total', 450, 'Doação sem intercorrências', FALSE);

-- ESTOQUE_SANGUE
INSERT INTO estoque_sangue (hemocentro_id, tipo_sanguineo, fator_rh, quantidade_bolsas, nivel_estoque, data_validade_proxima) VALUES
(1, 'A', 'Positivo', 85, 'adequado', '2025-03-15'),
(1, 'A', 'Negativo', 22, 'baixo', '2025-03-10'),
(1, 'B', 'Positivo', 45, 'adequado', '2025-03-20'),
(1, 'B', 'Negativo', 8, 'critico', '2025-03-05'),
(1, 'AB', 'Positivo', 35, 'adequado', '2025-03-18'),
(1, 'AB', 'Negativo', 12, 'baixo', '2025-03-08'),
(1, 'O', 'Positivo', 120, 'excelente', '2025-03-25'),
(1, 'O', 'Negativo', 9, 'critico', '2025-03-12');

-- NOTIFICACOES
INSERT INTO notificacao (doador_id, administrador_id, tipo, titulo, mensagem, canal, enviada, lida, data_envio) VALUES
(1, 2, 'confirmacao_agendamento', 'Agendamento Confirmado', 'Seu agendamento para doação foi confirmado para 18/02/2025 às 08:00h no Hemocentro Regional.', 'email', TRUE, TRUE, '2025-01-20 10:30:00'),
(2, 2, 'confirmacao_agendamento', 'Agendamento Confirmado', 'Seu agendamento para doação foi confirmado para 20/02/2025 às 09:30h no Hemocentro Regional.', 'email', TRUE, FALSE, '2025-01-22 14:15:00'),
(3, 2, 'lembrete_doacao', 'Você pode doar novamente!', 'Olá Pedro! Você já está apto para realizar uma nova doação de sangue. Agende sua próxima doação!', 'email', TRUE, FALSE, '2025-03-06 08:00:00'),
(5, NULL, 'estoque_critico', 'Estoque Crítico - Tipo O Negativo', 'O estoque de sangue tipo O negativo está crítico. Sua doação pode salvar vidas!', 'sms', TRUE, TRUE, '2025-01-18 09:00:00'),
(6, 2, 'campanha', 'Nova Campanha - Doadores de Primeira Vez', 'Participe da nossa campanha para incentivar novos doadores. Indique um amigo!', 'sistema', TRUE, FALSE, '2025-02-01 10:00:00'),
(7, 2, 'lembrete_doacao', 'Lembrete: Agendamento Amanhã', 'Lembrete: Você tem um agendamento para doação amanhã às 15:00h no Posto Shopping.', 'email', TRUE, FALSE, '2025-03-14 18:00:00'),
(10, 2, 'confirmacao_agendamento', 'Agendamento Confirmado', 'Seu agendamento foi confirmado para 10/03/2025 às 09:00h no Hemocentro Regional.', 'email', TRUE, FALSE, '2025-02-10 11:00:00');

-- RELATORIOS
INSERT INTO relatorio (administrador_id, tipo_relatorio, periodo_inicio, periodo_fim, dados_relatorio, formato_arquivo) VALUES
(1, 'doacoes_periodo', '2024-12-01', '2024-12-31', '{"total_doacoes": 285, "por_tipo": {"O+": 120, "A+": 85, "B+": 45, "AB+": 20, "O-": 8, "A-": 5, "B-": 1, "AB-": 1}}', 'pdf'),
(2, 'doadores_ativos', '2025-01-01', '2025-01-31', '{"total_doadores": 8, "novos_doadores": 2, "doadores_retorno": 6}', 'pdf'),
(1, 'estoque', '2025-02-01', '2025-02-15', '{"nivel_geral": "adequado", "tipos_criticos": ["O-", "B-"], "tipos_baixos": ["A-", "AB-"]}', 'pdf'),
(3, 'campanhas', '2024-12-01', '2024-12-31', '{"campanha": "Doação Solidária - Natal 2024", "meta": 300, "realizadas": 285, "percentual": 95}', 'pdf');
