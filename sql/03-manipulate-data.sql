-- ============================================
-- Script de Manipulação de Dados
-- Sistema: Sangue Solidário
-- ============================================

USE sangue_solidario;

-- ============================================
-- INSERÇÃO DE DADOS
-- ============================================

-- Inserir novo doador com endereço
INSERT INTO endereco (cep, logradouro, numero, complemento, bairro, cidade, estado) 
VALUES ('79600011', 'Rua Nova Esperança', '200', NULL, 'Jardim das Flores', 'Três Lagoas', 'MS');

INSERT INTO doador (nome, cpf, email, telefone, data_nascimento, genero, tipo_sanguineo, fator_rh, senha_hash, endereco_id) 
VALUES ('Novo Doador Silva', '11122233344', 'novo.doador@email.com', '67999111222', '1993-07-15', 'Masculino', 'A', 'Positivo', '$2y$10$novoDoador123', LAST_INSERT_ID());

-- Inserir novo agendamento
INSERT INTO agendamento (doador_id, local_doacao_id, campanha_id, data_agendamento, horario, status, tipo_doacao) 
VALUES (1, 1, 3, '2025-03-20', '10:00:00', 'pendente', 'Sangue Total');

-- Inserir nova campanha
INSERT INTO campanha (titulo, descricao, data_inicio, data_fim, tipo_sanguineo_alvo, status, meta_doacoes, administrador_id) 
VALUES ('Campanha Verão 2025', 'Campanha para período de férias', '2025-07-01', '2025-07-31', 'Todos', 'planejada', 250, 3);

-- Inserir notificação
INSERT INTO notificacao (doador_id, administrador_id, tipo, titulo, mensagem, canal, enviada) 
VALUES (1, 2, 'lembrete_doacao', 'Hora de Doar Novamente', 'Você está apto para uma nova doação!', 'email', FALSE);

-- Inserir estoque de sangue
INSERT INTO estoque_sangue (hemocentro_id, tipo_sanguineo, fator_rh, quantidade_bolsas, nivel_estoque) 
VALUES (1, 'A', 'Positivo', 50, 'adequado');

-- ============================================
-- ATUALIZAÇÃO DE DADOS
-- ============================================

-- Atualizar dados do doador
UPDATE doador 
SET telefone = '67999888777', email = 'joao.novo@email.com' 
WHERE id = 1;

-- Atualizar status do agendamento
UPDATE agendamento 
SET status = 'confirmado', data_confirmacao = NOW() 
WHERE id = 1;

-- Atualizar contador de doações
UPDATE doador 
SET contador_doacoes = contador_doacoes + 1, ultima_doacao = CURDATE(), proxima_doacao_permitida = DATE_ADD(CURDATE(), INTERVAL 60 DAY) 
WHERE id = 1;

-- Atualizar estoque de sangue
UPDATE estoque_sangue 
SET quantidade_bolsas = quantidade_bolsas + 5, nivel_estoque = 'adequado', ultima_atualizacao = NOW() 
WHERE hemocentro_id = 1 AND tipo_sanguineo = 'O' AND fator_rh = 'Negativo';

-- Atualizar campanha - incrementar doações realizadas
UPDATE campanha 
SET doacoes_realizadas = doacoes_realizadas + 1 
WHERE id = 3;

-- Marcar notificação como lida
UPDATE notificacao 
SET lida = TRUE, data_leitura = NOW() 
WHERE id = 1;

-- Atualizar status da campanha
UPDATE campanha 
SET status = 'ativa' 
WHERE id = 1 AND data_inicio <= CURDATE() AND data_fim >= CURDATE();

-- Atualizar elegibilidade do doador
UPDATE doador 
SET elegivel = TRUE 
WHERE proxima_doacao_permitida <= CURDATE();

-- ============================================
-- DELEÇÃO DE DADOS
-- ============================================

-- Deletar agendamento cancelado
DELETE FROM agendamento 
WHERE id = 5 AND status = 'cancelado';

-- Deletar notificações antigas lidas
DELETE FROM notificacao 
WHERE lida = TRUE AND data_leitura < DATE_SUB(NOW(), INTERVAL 90 DAY);

-- Deletar campanhas canceladas antigas
DELETE FROM campanha 
WHERE status = 'cancelada' AND data_fim < DATE_SUB(CURDATE(), INTERVAL 1 YEAR);

-- Deletar doador (cascata deleta endereço)
DELETE FROM doador 
WHERE id = 999;

-- ============================================
-- CONSULTAS BÁSICAS
-- ============================================

-- Listar todos os doadores
SELECT * FROM doador;

-- Listar doadores por tipo sanguíneo
SELECT id, nome, email, tipo_sanguineo, fator_rh, contador_doacoes 
FROM doador 
WHERE tipo_sanguineo = 'O' AND fator_rh = 'Positivo';

-- Listar doadores elegíveis
SELECT id, nome, email, telefone, tipo_sanguineo, fator_rh, proxima_doacao_permitida 
FROM doador 
WHERE elegivel = TRUE;

-- Listar agendamentos do dia
SELECT a.id, d.nome, d.telefone, a.data_agendamento, a.horario, l.nome AS local, a.status 
FROM agendamento a 
JOIN doador d ON a.doador_id = d.id 
JOIN local_doacao l ON a.local_doacao_id = l.id 
WHERE a.data_agendamento = CURDATE() 
ORDER BY a.horario;

-- Listar agendamentos confirmados
SELECT a.id, d.nome, d.email, d.telefone, a.data_agendamento, a.horario, l.nome AS local 
FROM agendamento a 
JOIN doador d ON a.doador_id = d.id 
JOIN local_doacao l ON a.local_doacao_id = l.id 
WHERE a.status = 'confirmado' 
ORDER BY a.data_agendamento, a.horario;

-- Consultar estoque de sangue
SELECT tipo_sanguineo, fator_rh, quantidade_bolsas, nivel_estoque, data_validade_proxima 
FROM estoque_sangue 
WHERE hemocentro_id = 1 
ORDER BY nivel_estoque, quantidade_bolsas;

-- Consultar estoque crítico
SELECT tipo_sanguineo, fator_rh, quantidade_bolsas 
FROM estoque_sangue 
WHERE nivel_estoque = 'critico' 
ORDER BY quantidade_bolsas;

-- Histórico de doações por doador
SELECT hd.data_doacao, hd.local_doacao, hd.tipo_doacao, hd.volume_ml, hd.reacao_adversa 
FROM historico_doacoes hd 
WHERE hd.doador_id = 1 
ORDER BY hd.data_doacao DESC;

-- Listar campanhas ativas
SELECT id, titulo, descricao, data_inicio, data_fim, tipo_sanguineo_alvo, meta_doacoes, doacoes_realizadas 
FROM campanha 
WHERE status = 'ativa' 
ORDER BY data_fim;

-- Notificações não lidas por doador
SELECT id, tipo, titulo, mensagem, data_envio 
FROM notificacao 
WHERE doador_id = 1 AND lida = FALSE 
ORDER BY data_envio DESC;

-- ============================================
-- CONSULTAS AVANÇADAS
-- ============================================

-- Top 10 doadores mais ativos
SELECT d.id, d.nome, d.email, d.tipo_sanguineo, d.fator_rh, d.contador_doacoes 
FROM doador d 
ORDER BY d.contador_doacoes DESC 
LIMIT 10;

-- Doadores que nunca doaram
SELECT d.id, d.nome, d.email, d.telefone, d.tipo_sanguineo, d.fator_rh 
FROM doador d 
WHERE d.contador_doacoes = 0;

-- Total de doações por tipo sanguíneo
SELECT d.tipo_sanguineo, d.fator_rh, COUNT(hd.id) AS total_doacoes 
FROM doador d 
LEFT JOIN historico_doacoes hd ON d.id = hd.doador_id 
GROUP BY d.tipo_sanguineo, d.fator_rh 
ORDER BY total_doacoes DESC;

-- Doações por período
SELECT DATE_FORMAT(data_doacao, '%Y-%m') AS mes, COUNT(*) AS total_doacoes 
FROM historico_doacoes 
WHERE data_doacao BETWEEN '2024-01-01' AND '2024-12-31' 
GROUP BY mes 
ORDER BY mes;

-- Taxa de comparecimento aos agendamentos
SELECT 
    COUNT(*) AS total_agendamentos,
    SUM(CASE WHEN compareceu = TRUE THEN 1 ELSE 0 END) AS compareceram,
    SUM(CASE WHEN status = 'faltou' THEN 1 ELSE 0 END) AS faltaram,
    ROUND((SUM(CASE WHEN compareceu = TRUE THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS taxa_comparecimento
FROM agendamento 
WHERE data_agendamento < CURDATE();

-- Doadores aptos para doar por tipo sanguíneo
SELECT tipo_sanguineo, fator_rh, COUNT(*) AS doadores_aptos 
FROM doador 
WHERE elegivel = TRUE 
GROUP BY tipo_sanguineo, fator_rh 
ORDER BY doadores_aptos DESC;

-- Campanhas com melhor desempenho
SELECT 
    id, 
    titulo, 
    meta_doacoes, 
    doacoes_realizadas, 
    ROUND((doacoes_realizadas / meta_doacoes) * 100, 2) AS percentual_atingido 
FROM campanha 
WHERE status IN ('ativa', 'concluida') 
ORDER BY percentual_atingido DESC;

-- Locais com mais agendamentos
SELECT 
    l.nome, 
    COUNT(a.id) AS total_agendamentos 
FROM local_doacao l 
LEFT JOIN agendamento a ON l.id = a.local_doacao_id 
GROUP BY l.id, l.nome 
ORDER BY total_agendamentos DESC;

-- Doadores que não comparecem
SELECT 
    d.id, 
    d.nome, 
    d.email, 
    COUNT(a.id) AS total_faltas 
FROM doador d 
JOIN agendamento a ON d.id = a.doador_id 
WHERE a.status = 'faltou' 
GROUP BY d.id, d.nome, d.email 
HAVING total_faltas > 2 
ORDER BY total_faltas DESC;

-- Relatório completo de doador
SELECT 
    d.nome,
    d.email,
    d.telefone,
    d.tipo_sanguineo,
    d.fator_rh,
    d.contador_doacoes,
    d.ultima_doacao,
    d.proxima_doacao_permitida,
    d.elegivel,
    e.cidade,
    e.estado
FROM doador d
JOIN endereco e ON d.endereco_id = e.id
WHERE d.id = 1;

-- Estatísticas gerais do sistema
SELECT 
    (SELECT COUNT(*) FROM doador) AS total_doadores,
    (SELECT COUNT(*) FROM doador WHERE elegivel = TRUE) AS doadores_elegiveis,
    (SELECT COUNT(*) FROM agendamento WHERE status = 'confirmado') AS agendamentos_confirmados,
    (SELECT COUNT(*) FROM campanha WHERE status = 'ativa') AS campanhas_ativas,
    (SELECT SUM(quantidade_bolsas) FROM estoque_sangue) AS total_bolsas_estoque,
    (SELECT COUNT(*) FROM historico_doacoes WHERE YEAR(data_doacao) = YEAR(CURDATE())) AS doacoes_ano_atual;
