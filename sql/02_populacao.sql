-- ============================================================================
-- PROJETO INTEGRADOR: JOINSHOP (LOJA VIRTUAL)
-- SCRIPT: 02_populacao.sql
-- OBJETIVO: Popular as 6 tabelas com 73 registros coerentes e cenários reais
-- ============================================================================

-- Limpa eventuais registros de testes anteriores e reinicia os IDs a partir de 1
TRUNCATE TABLE pagamento, item_pedido, pedido, produto, endereco, cliente RESTART IDENTITY CASCADE;

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
('Mouse Sem Fio Ergonômico', 'Mouse óptico wireless 2.4GHz recarregável',           129.90, 45, '7891000100028', TRUE),
('Teclado Mecânico RGB',     'Teclado ABNT2 switch brown com iluminação RGB',       349.90, 28, '7891000100035', TRUE),
('Monitor 27" IPS Full HD',  'Monitor 75Hz borda infinita HDMI/DisplayPort',       1199.00, 15, '7891000100042', TRUE),
('Headset Gamer Surround 7.1','Fone com microfone removível e cancelamento de ruído',289.90, 30, '7891000100059', TRUE),
('Webcam Full HD 1080p',     'Webcam com foco automático e microfone embutido',     219.90, 20, '7891000100066', TRUE),
('SSD NVMe 1TB PCIe 4.0',    'Armazenamento ultrarrápido leitura até 5000MB/s',      549.90, 18, '7891000100073', TRUE),
('Cadeira Ergonomica Mesh',  'Cadeira de escritório com ajuste lombar e braços 3D', 1350.00,  6, '7891000100080', TRUE),
('Hub USB-C 7 em 1',         'Adaptador HDMI 4K, 3x USB 3.0, SD/MicroSD e PD',      179.90, 40, '7891000100097', TRUE),
('Suporte Articulado Monitor','Braço articulado a gás para monitores até 32"',      249.90,  0, '7891000100103', TRUE), -- Estoque zerado
('Mochila Executiva Notebook','Mochila impermeável até 15.6" com entrada USB',      199.90, 25, '7891000100110', TRUE), -- Produto sem vendas (para LEFT JOIN)
('Tablet Básico 8" (Antigo)','Modelo descontinuado 32GB Wi-Fi',                     699.00,  2, '7891000100127', FALSE); -- Inativo

-- 4. PEDIDOS (12 registros: cobrindo status Pago, Aguardando Pagamento, Enviado, Entregue e Cancelado)
INSERT INTO pedido (id_cliente, id_endereco, data_pedido, valor_frete, valor_desconto, status_pedido) VALUES
(1, 1, '2026-10-05 10:15:00', 25.00, 100.00, 'Entregue'),            -- Pedido 1 (Ana)
(2, 3, '2026-10-12 14:30:00', 15.00,   0.00, 'Entregue'),            -- Pedido 2 (Bruno)
(3, 4, '2026-10-18 09:45:00', 35.00,  50.00, 'Entregue'),            -- Pedido 3 (Camila)
(1, 2, '2026-11-02 16:20:00',  0.00,  20.00, 'Enviado'),             -- Pedido 4 (Ana - 2º pedido, endereço comercial)
(4, 6, '2026-11-05 11:00:00', 30.00,   0.00, 'Pago'),                -- Pedido 5 (Diego)
(5, 7, '2026-11-08 19:10:00', 20.00,  15.00, 'Cancelado'),           -- Pedido 6 (Eduarda - cancelado)
(6, 8, '2026-11-10 08:50:00', 40.00,   0.00, 'Pago'),                -- Pedido 7 (Felipe)
(2, 3, '2026-11-14 15:40:00', 15.00,  30.00, 'Aguardando Pagamento'),-- Pedido 8 (Bruno - pendente)
(7, 9, '2026-11-16 17:05:00', 18.00,   0.00, 'Enviado'),             -- Pedido 9 (Gabriela)
(9, 11,'2026-09-20 13:00:00', 22.00,   0.00, 'Entregue'),            -- Pedido 10 (Isabela - cliente hoje inativa, histórico preservado)
(3, 4, '2026-11-20 20:15:00', 35.00,   0.00, 'Aguardando Pagamento'),-- Pedido 11 (Camila - pendente)
(5, 7, '2026-11-22 12:30:00', 20.00,  50.00, 'Pago');                -- Pedido 12 (Eduarda - nova compra aprovada)

-- 5. ITEM_PEDIDO (16 registros: relacionando pedidos e produtos com preço histórico)
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1,  1, 1, 4599.90), -- Pedido 1: Notebook
(1,  2, 1,  129.90), -- Pedido 1: Mouse
(2,  3, 1,  349.90), -- Pedido 2: Teclado
(2,  5, 1,  289.90), -- Pedido 2: Headset
(3,  4, 2, 1199.00), -- Pedido 3: 2x Monitores
(4,  7, 1,  549.90), -- Pedido 4: SSD 1TB
(4,  9, 2,  179.90), -- Pedido 4: 2x Hub USB-C
(5,  8, 1, 1350.00), -- Pedido 5: Cadeira Ergonômica
(6,  6, 1,  219.90), -- Pedido 6: Webcam (pedido cancelado)
(7,  1, 1, 4499.90), -- Pedido 7: Notebook (comprado em promoção histórica por 4499.90!)
(8,  2, 2,  129.90), -- Pedido 8: 2x Mouses (aguardando pagamento)
(9,  5, 1,  289.90), -- Pedido 9: Headset
(9,  6, 1,  219.90), -- Pedido 9: Webcam
(10, 12,1,  699.00), -- Pedido 10: Tablet antigo (histórico de produto hoje inativo)
(11, 10,1,  249.90), -- Pedido 11: Suporte Articulado (aguardando pagamento)
(12, 3, 1,  349.90); -- Pedido 12: Teclado Mecânico

-- 6. PAGAMENTOS (11 registros: aprovados, recusados e retentativa de pagamento)
INSERT INTO pagamento (id_pedido, forma_pagamento, valor_pago, status_pagamento, data_pagamento) VALUES
(1,  'Cartão de Crédito', 4654.80, 'Aprovado',  '2026-10-05 10:17:00'), -- (4599.90 + 129.90 + 25.00 - 100.00)
(2,  'PIX',                654.80, 'Aprovado',  '2026-10-12 14:32:00'), -- (349.90 + 289.90 + 15.00)
(3,  'Cartão de Crédito', 2383.00, 'Aprovado',  '2026-10-18 09:48:00'), -- (2398.00 + 35.00 - 50.00)
(4,  'PIX',                889.70, 'Aprovado',  '2026-11-02 16:21:00'), -- (549.90 + 359.80 + 0.00 - 20.00)
(5,  'Boleto',            1380.00, 'Aprovado',  '2026-11-06 08:00:00'), -- (1350.00 + 30.00)
(6,  'Cartão de Crédito',  224.90, 'Recusado',  '2026-11-08 19:12:00'), -- Pagamento recusado -> Pedido 6 cancelado
(7,  'Cartão de Crédito', 4539.90, 'Recusado',  '2026-11-10 08:51:00'), -- 1ª tentativa recusada
(7,  'PIX',               4539.90, 'Aprovado',  '2026-11-10 08:55:00'), -- 2ª tentativa aprovada (1:N entre Pedido e Pagamento!)
(9,  'PIX',                527.80, 'Aprovado',  '2026-11-16 17:06:00'), -- (289.90 + 219.90 + 18.00)
(10, 'Cartão de Crédito',  721.00, 'Aprovado',  '2026-09-20 13:05:00'), -- (699.00 + 22.00)
(12, 'PIX',                319.90, 'Aprovado',  '2026-11-22 12:31:00'); -- (349.90 + 20.00 - 50.00)

-- TOTAL DE REGISTROS INSERIDOS: 10 + 12 + 12 + 12 + 16 + 11 = 73 REGISTROS!
