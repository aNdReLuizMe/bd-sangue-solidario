-- ============================================
-- Script de Criação do Banco de Dados
-- Sistema: Sangue Solidário
-- ============================================

-- Criar banco de dados
CREATE DATABASE IF NOT EXISTS sangue_solidario 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE sangue_solidario;

-- Tabela: ENDERECO
CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cep VARCHAR(8) NOT NULL,
    logradouro VARCHAR(200) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabela: DOADOR
CREATE TABLE doador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    data_nascimento DATE NOT NULL,
    genero ENUM('Masculino', 'Feminino', 'Outro') NOT NULL,
    tipo_sanguineo ENUM('A', 'B', 'AB', 'O') NOT NULL,
    fator_rh ENUM('Positivo', 'Negativo') NOT NULL,
    elegivel BOOLEAN DEFAULT TRUE,
    contador_doacoes INT DEFAULT 0,
    ultima_doacao DATE,
    proxima_doacao_permitida DATE,
    senha_hash VARCHAR(255) NOT NULL,
    endereco_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (endereco_id) REFERENCES endereco(id) ON DELETE CASCADE,
    INDEX idx_tipo_sangue (tipo_sanguineo, fator_rh),
    INDEX idx_proxima_doacao (proxima_doacao_permitida),
    INDEX idx_elegivel (elegivel)
) ENGINE=InnoDB;

-- Tabela: HEMOCENTRO
CREATE TABLE hemocentro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    cnpj VARCHAR(14) UNIQUE NOT NULL,
    endereco_completo VARCHAR(500) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(150) NOT NULL,
    responsavel_tecnico VARCHAR(200) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Tabela: ADMINISTRADOR
CREATE TABLE administrador (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    nivel_acesso ENUM('super_admin', 'admin', 'coordenador', 'operador') NOT NULL,
    hemocentro_id INT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    ultimo_acesso TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hemocentro_id) REFERENCES hemocentro(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabela: LOCAL_DOACAO
CREATE TABLE local_doacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    endereco_completo VARCHAR(500) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    horario_funcionamento VARCHAR(200) NOT NULL,
    capacidade_diaria INT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CHECK (capacidade_diaria > 0)
) ENGINE=InnoDB;

-- Tabela: CAMPANHA
CREATE TABLE campanha (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    tipo_sanguineo_alvo ENUM('A', 'B', 'AB', 'O', 'Todos'),
    status ENUM('planejada', 'ativa', 'concluida', 'cancelada') DEFAULT 'planejada',
    meta_doacoes INT NOT NULL,
    doacoes_realizadas INT DEFAULT 0,
    administrador_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (administrador_id) REFERENCES administrador(id) ON DELETE RESTRICT,
    CHECK (data_fim >= data_inicio),
    CHECK (meta_doacoes > 0),
    CHECK (doacoes_realizadas <= meta_doacoes),
    INDEX idx_status (status),
    INDEX idx_datas (data_inicio, data_fim)
) ENGINE=InnoDB;

-- Tabela: AGENDAMENTO
CREATE TABLE agendamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doador_id INT NOT NULL,
    local_doacao_id INT NOT NULL,
    campanha_id INT,
    data_agendamento DATE NOT NULL,
    horario TIME NOT NULL,
    status ENUM('pendente', 'confirmado', 'realizado', 'cancelado', 'faltou') DEFAULT 'pendente',
    tipo_doacao ENUM('Sangue Total', 'Plaquetas', 'Plasma') DEFAULT 'Sangue Total',
    compareceu BOOLEAN DEFAULT FALSE,
    observacoes TEXT,
    data_confirmacao TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doador_id) REFERENCES doador(id) ON DELETE CASCADE,
    FOREIGN KEY (local_doacao_id) REFERENCES local_doacao(id) ON DELETE RESTRICT,
    FOREIGN KEY (campanha_id) REFERENCES campanha(id) ON DELETE SET NULL,
    INDEX idx_doador (doador_id),
    INDEX idx_data_hora (data_agendamento, horario),
    INDEX idx_status (status)
) ENGINE=InnoDB;

-- Tabela: HISTORICO_DOACOES
CREATE TABLE historico_doacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doador_id INT NOT NULL,
    data_doacao DATE NOT NULL,
    local_doacao VARCHAR(200) NOT NULL,
    tipo_doacao VARCHAR(50) NOT NULL,
    volume_ml INT NOT NULL,
    observacoes_medicas TEXT,
    reacao_adversa BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doador_id) REFERENCES doador(id) ON DELETE CASCADE,
    CHECK (volume_ml BETWEEN 300 AND 500),
    INDEX idx_doador (doador_id),
    INDEX idx_data (data_doacao)
) ENGINE=InnoDB;

-- Tabela: ESTOQUE_SANGUE
CREATE TABLE estoque_sangue (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hemocentro_id INT NOT NULL,
    tipo_sanguineo ENUM('A', 'B', 'AB', 'O') NOT NULL,
    fator_rh ENUM('Positivo', 'Negativo') NOT NULL,
    quantidade_bolsas INT NOT NULL DEFAULT 0,
    nivel_estoque ENUM('critico', 'baixo', 'adequado', 'excelente') NOT NULL,
    data_validade_proxima DATE,
    ultima_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hemocentro_id) REFERENCES hemocentro(id) ON DELETE CASCADE,
    UNIQUE KEY uk_estoque (hemocentro_id, tipo_sanguineo, fator_rh),
    CHECK (quantidade_bolsas >= 0),
    INDEX idx_nivel (nivel_estoque)
) ENGINE=InnoDB;

-- Tabela: NOTIFICACAO
CREATE TABLE notificacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doador_id INT NOT NULL,
    administrador_id INT,
    tipo ENUM('lembrete_doacao', 'campanha', 'estoque_critico', 'confirmacao_agendamento', 'cancelamento') NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    mensagem TEXT NOT NULL,
    canal ENUM('email', 'sms', 'push', 'sistema') NOT NULL,
    enviada BOOLEAN DEFAULT FALSE,
    lida BOOLEAN DEFAULT FALSE,
    data_envio TIMESTAMP NULL,
    data_leitura TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (doador_id) REFERENCES doador(id) ON DELETE CASCADE,
    FOREIGN KEY (administrador_id) REFERENCES administrador(id) ON DELETE SET NULL,
    INDEX idx_doador_lida (doador_id, lida),
    INDEX idx_data_envio (data_envio)
) ENGINE=InnoDB;

-- Tabela: RELATORIO
CREATE TABLE relatorio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    administrador_id INT NOT NULL,
    tipo_relatorio ENUM('doacoes_periodo', 'doadores_ativos', 'campanhas', 'estoque', 'agendamentos') NOT NULL,
    periodo_inicio DATE NOT NULL,
    periodo_fim DATE NOT NULL,
    dados_relatorio JSON,
    formato_arquivo VARCHAR(10) DEFAULT 'pdf',
    data_geracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (administrador_id) REFERENCES administrador(id) ON DELETE RESTRICT
) ENGINE=InnoDB;
