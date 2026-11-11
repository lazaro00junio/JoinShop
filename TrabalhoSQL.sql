-- ==========================================
-- TABELA CLIENTE
-- ==========================================

CREATE TABLE IF NOT EXISTS cliente (
    id_cliente INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20),

    PRIMARY KEY (id_cliente)
);


-- ==========================================
-- TABELA ENDERECO
-- ==========================================

CREATE TABLE IF NOT EXISTS endereco (
    id_endereco INTEGER GENERATED ALWAYS AS IDENTITY,
    id_cliente INTEGER NOT NULL,
    cep VARCHAR(9) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    tipo_endereco VARCHAR(30) NOT NULL,

    PRIMARY KEY (id_endereco),

    CONSTRAINT fk_endereco_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);


-- ==========================================
-- TABELA PRODUTO
-- ==========================================

CREATE TABLE IF NOT EXISTS produto (
    id_produto INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL
        CHECK (preco >= 0),
    codigo_barras VARCHAR(50) UNIQUE,

    PRIMARY KEY (id_produto)
);


-- ==========================================
-- TABELA ESTOQUE
-- ==========================================

CREATE TABLE IF NOT EXISTS estoque (
    id_estoque INTEGER GENERATED ALWAYS AS IDENTITY,
    id_produto INTEGER NOT NULL UNIQUE,
    quantidade INTEGER NOT NULL DEFAULT 0
        CHECK (quantidade >= 0),

    PRIMARY KEY (id_estoque),

    CONSTRAINT fk_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);


-- ==========================================
-- TABELA PEDIDO
-- ==========================================

CREATE TABLE IF NOT EXISTS pedido (
    id_pedido INTEGER GENERATED ALWAYS AS IDENTITY,
    id_cliente INTEGER NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30) NOT NULL
        CHECK (
            status_pedido IN (
                'Aguardando Pagamento',
                'Pago',
                'Enviado',
                'Entregue',
                'Cancelado'
            )
        ),

    PRIMARY KEY (id_pedido),

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES cliente (id_cliente)
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);


-- ==========================================
-- TABELA ITEM_PEDIDO
-- ==========================================

CREATE TABLE IF NOT EXISTS item_pedido (
    id_item_pedido INTEGER GENERATED ALWAYS AS IDENTITY,
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL
        CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL
        CHECK (preco_unitario >= 0),

    PRIMARY KEY (id_item_pedido),

    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,

    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto)
        REFERENCES produto (id_produto)
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
);


-- ==========================================
-- TABELA PAGAMENTO
-- ==========================================

CREATE TABLE IF NOT EXISTS pagamento (
    id_pagamento INTEGER GENERATED ALWAYS AS IDENTITY,
    id_pedido INTEGER NOT NULL UNIQUE,
    forma_pagamento VARCHAR(30) NOT NULL
        CHECK (
            forma_pagamento IN (
                'Cartão de Crédito',
                'PIX',
                'Boleto',
                'Cartão de Débito'
            )
        ),
    valor_pago DECIMAL(10,2) NOT NULL
        CHECK (valor_pago > 0),
    status_pagamento VARCHAR(20) NOT NULL
        CHECK (
            status_pagamento IN (
                'Pendente',
                'Aprovado',
                'Recusado',
                'Estornado'
            )
        ),
    data_pagamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_pagamento),

    CONSTRAINT fk_pagamento_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedido (id_pedido)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
