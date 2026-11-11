CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefone VARCHAR(20)
);

CREATE TABLE endereco (
    id_endereco SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    cep VARCHAR(9) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    tipo_endereco VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL CHECK (preco >= 0),
    codigo_barras VARCHAR(50) UNIQUE
);

CREATE TABLE estoque (
    id_estoque SERIAL PRIMARY KEY,
    id_produto INTEGER NOT NULL UNIQUE,
    quantidade INTEGER NOT NULL DEFAULT 0
        CHECK (quantidade >= 0),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
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
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE item_pedido (
    id_item_pedido SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL,
    id_produto INTEGER NOT NULL,
    quantidade INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL
        CHECK (preco_unitario >= 0),
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

CREATE TABLE pagamento (
    id_pagamento SERIAL PRIMARY KEY,
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
    FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido)
);
