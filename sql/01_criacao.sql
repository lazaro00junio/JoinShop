--DROP DATABASE IF EXISTS joinshop;
CREATE DATABASE joinshop;

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    cep VARCHAR(9) NOT NULL,
    logradouro VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    uf CHAR(2) NOT NULL,
    tipo_endereco VARCHAR(30) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT
);

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
    quantidade_estoque INTEGER NOT NULL CHECK (quantidade_estoque >= 0),
    codigo_barras VARCHAR(50) UNIQUE,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    id_endereco INTEGER NOT NULL,
    data_pedido TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_frete DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (valor_frete >= 0),
    valor_desconto DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (valor_desconto >= 0),
    status_pedido VARCHAR(30) NOT NULL DEFAULT 'Aguardando Pagamento'
        CHECK (
            status_pedido IN (
                'Aguardando Pagamento',
                'Pago',
                'Enviado',
                'Entregue',
                'Cancelado'
            )
        ),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT,
    FOREIGN KEY (id_endereco) REFERENCES endereco(id_endereco) ON DELETE RESTRICT
);

CREATE TABLE item_pedido (
    id_item_pedido SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL CHECK (preco_unitario >= 0),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto) ON DELETE RESTRICT,
    UNIQUE (id_pedido, id_produto)
);

CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL
        CHECK (
            forma_pagamento IN (
                'Cartão de Crédito',
                'PIX',
                'Boleto',
                'Cartão de Débito'
            )
        ),
    valor_pago DECIMAL(10,2) NOT NULL CHECK (valor_pago > 0),
    status_pagamento VARCHAR(20) NOT NULL DEFAULT 'Pendente'
        CHECK (
            status_pagamento IN (
                'Pendente',
                'Aprovado',
                'Recusado',
                'Estornado'
            )
        ),
    data_pagamento TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido) ON DELETE RESTRICT
);

CREATE UNIQUE INDEX idx_pagamento_unico_aprovado
    ON pagamento (id_pedido)
    WHERE status_pagamento = 'Aprovado';

CREATE INDEX idx_endereco_cliente ON endereco (id_cliente);
CREATE INDEX idx_pedido_cliente ON pedido (id_cliente);
CREATE INDEX idx_pedido_endereco ON pedido (id_endereco);
CREATE INDEX idx_item_pedido_pedido ON item_pedido (id_pedido);
CREATE INDEX idx_item_pedido_produto ON item_pedido (id_produto);
CREATE INDEX idx_pagamento_pedido ON pagamento (id_pedido);