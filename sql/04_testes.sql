-- ============================================================================
-- PROJETO INTEGRADOR: JOINSHOP (E-COMMERCE B2C)
-- SCRIPT: 04_testes.sql
-- OBJETIVO: Testes de manipulação (DML), integridade referencial e transação
-- ============================================================================

-- PARTE 1: OPERAÇÕES DE MANIPULAÇÃO DE DADOS (INSERT, UPDATE, DELETE)
INSERT INTO produto (nome, descricao, preco, quantidade_estoque, codigo_barras, ativo)
VALUES ('Webcam 4K Ultra HD', 'Webcam profissional com lente de vidro e HDR', 499.90, 15, '7899990009991', TRUE);

UPDATE produto
SET preco = 449.90,
    quantidade_estoque = 12
WHERE codigo_barras = '7899990009991';

DELETE FROM produto
WHERE codigo_barras = '7899990009991';

-- PARTE 2: TESTES DE INTEGRIDADE E REGRAS DE NEGÓCIO (BLOQUEIOS ESPERADOS)
-- (Descomente individualmente para evidenciar os bloqueios das constraints)
-- INSERT INTO produto (nome, preco, quantidade_estoque) VALUES ('Produto Inválido', -50.00, 10);
-- INSERT INTO pagamento (id_pedido, forma_pagamento, valor_pago, status_pagamento) VALUES (1, 'PIX', 4654.80, 'Aprovado');
-- DELETE FROM cliente WHERE id_cliente = 1;

-- PARTE 3: TRANSAÇÃO ATÔMICA MULTI-OPERAÇÃO (BEGIN / COMMIT)
BEGIN;

WITH novo_pedido AS (
    INSERT INTO pedido (id_cliente, id_endereco, valor_frete, valor_desconto, status_pedido)
    VALUES (2, 3, 15.00, 0.00, 'Pago')
    RETURNING id_pedido
),
novo_item AS (
    INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario)
    SELECT id_pedido, 2, 1, (SELECT preco FROM produto WHERE id_produto = 2)
    FROM novo_pedido
    RETURNING id_pedido, id_produto, quantidade, preco_unitario
),
baixa_estoque AS (
    UPDATE produto
    SET quantidade_estoque = quantidade_estoque - (SELECT quantidade FROM novo_item)
    WHERE id_produto = (SELECT id_produto FROM novo_item)
    RETURNING id_produto, quantidade_estoque
)
INSERT INTO pagamento (id_pedido, forma_pagamento, valor_pago, status_pagamento)
SELECT 
    ni.id_pedido,
    'PIX',
    (ni.quantidade * ni.preco_unitario) + 15.00,
    'Aprovado'
FROM novo_item ni;

COMMIT;

-- Conferência final da transação efetivada:
SELECT 
    p.id_pedido,
    c.nome AS cliente,
    p.status_pedido,
    pg.forma_pagamento,
    pg.valor_pago,
    pg.status_pagamento,
    pr.nome AS produto_comprado,
    pr.quantidade_estoque AS estoque_atualizado
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
INNER JOIN pagamento pg ON p.id_pedido = pg.id_pedido
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
INNER JOIN produto pr ON ip.id_produto = pr.id_produto
ORDER BY p.id_pedido DESC
LIMIT 1;
