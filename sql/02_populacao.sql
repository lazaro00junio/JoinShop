-- ============================================================================
-- PROJETO INTEGRADOR: JOINSHOP (LOJA VIRTUAL)
-- SCRIPT: 02_populacao.sql
-- OBJETIVO: Popular as 6 tabelas com 73 registros coerentes e cenários reais
-- ============================================================================

-- 1. CLIENTES (10 registros: 8 ativos, 2 inativos via soft delete)
INSERT INTO cliente (nome, cpf, email, telefone, ativo) VALUES
('Ana Clara Silva',       '111.222.333-44', 'ana.silva@email.com',      '(34) 99101-1001', TRUE),
('Bruno Henrique Costa',  '222.333.444-55', 'bruno.costa@email.com',    '(34) 99102-1002', TRUE),
('Camila Ferreira Lima',  '333.444.555-66', 'camila.lima@email.com',    '(11) 99103-1003', TRUE),
('Diego Alves Martins',   '444.555.666-77', 'diego.martins@email.com',  '(31) 99104-1004', TRUE),
('Eduarda Santos Rocha',  '555.666.777-88', 'eduarda.rocha@email.com',  '(34) 99105-1005', TRUE),
('Felipe Oliveira Souza', '666.777.888-99', 'felipe.souza@email.com',   '(21) 99106-1006', TRUE),
('Gabriela Mendes Dias',  '777.888.999-00', 'gabriela.dias@email.com',  '(34) 99107-1007', TRUE),
('Henrique Barbosa Luz',  '888.999.000-11', 'henrique.luz@email.com',   '(11) 99108-1008', TRUE),
('Isabela Nunes Castro',  '999.000.111-22', 'isabela.castro@email.com', '(34) 99109-1009', FALSE), -- Inativo com histórico
('João Pedro Teixeira',   '000.111.222-33', 'joao.teixeira@email.com',  '(19) 99110-1010', FALSE); -- Inativo sem pedidos

-- 2. ENDERECOS (12 registros: clientes com múltiplos endereços e endereços inativos)
INSERT INTO endereco (id_cliente, cep, logradouro, numero, complemento, bairro, cidade, uf, tipo_endereco, ativo) VALUES
(1, '38400-100', 'Av. João Naves de Ávila', '1331', 'Apto 402',   'Santa Mônica',   'Uberlândia',     'MG', 'Residencial', TRUE),
(1, '38408-200', 'Rua Duque de Caxias',     '450',  'Sala 12',    'Centro',         'Uberlândia',     'MG', 'Comercial',   TRUE),
(2, '38400-300', 'Av. Rondon Pacheco',      '2100', NULL,         'Saraiva',        'Uberlândia',     'MG', 'Residencial', TRUE),
(3, '01310-100', 'Av. Paulista',            '1578', 'Conj. 84',   'Bela Vista',     'São Paulo',      'SP', 'Comercial',   TRUE),
(3, '04538-132', 'Av. Brigadeiro Faria Lima','3477','Bloco B',    'Itaim Bibi',     'São Paulo',      'SP', 'Residencial', FALSE), -- Endereço antigo inativo
(4, '30130-003', 'Av. Afonso Pena',         '980',  'Apto 1101',  'Centro',         'Belo Horizonte', 'MG', 'Residencial', TRUE),
(5, '38411-145', 'Rua Nicomedes Alves',     '720',  'Casa',       'Morada da Colina','Uberlândia',    'MG', 'Residencial', TRUE),
(6, '22041-001', 'Av. Atlântica',           '1702', 'Apto 601',   'Copacabana',     'Rio de Janeiro', 'RJ', 'Residencial', TRUE),
(7, '38405-142', 'Rua Coronel Antônio Alves','315', NULL,         'Fundinho',       'Uberlândia',     'MG', 'Residencial', TRUE),
(8, '05407-002', 'Rua Cardeal Arcoverde',   '1120', 'Casa 2',     'Pinheiros',      'São Paulo',      'SP', 'Residencial', TRUE),
(9, '38400-450', 'Av. Floriano Peixoto',    '610',  'Apto 205',   'Centro',         'Uberlândia',     'MG', 'Residencial', FALSE),
(10,'13015-001', 'Av. Francisco Glicério',  '890',  NULL,         'Centro',         'Campinas',       'SP', 'Residencial', TRUE);

-- 3. PRODUTOS (12 registros: preços variados, estoque alto, baixo, zerado e produto inativo)
INSERT INTO produto (nome, descricao, preco, quantidade_estoque, codigo_barras, ativo) VALUES
('Notebook Pro 15"',         'Notebook Intel Core i7, 16GB RAM, SSD 512GB',        4599.90, 12, '7891000100011', TRUE),
('Mouse Sem Fio Ergonômico', 'Mouse óptico wireless 2.4GHz recarregável',
