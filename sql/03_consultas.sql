-- Consulta 1: Produtos ativos com estoque crítico ou baixo para reposição
SELECT 
    id_produto,
    nome,
    preco,
    quantidade_estoque
FROM produto
WHERE ativo = TRUE 
  AND quantidade_estoque < 15
ORDER BY quantidade_estoque ASC;

-- Consulta 2: Pedidos recentes que ainda não foram finalizados nem cancelados
SELECT 
    id_pedido,
    id_cliente,
    data_pedido,
    valor_frete,
    valor_desconto,
    status_pedido
FROM pedido
WHERE data_pedido >= '2026-11-01 00:00:00'
  AND (status_pedido = 'Aguardando Pagamento' OR status_pedido = 'Pago')
ORDER BY data_pedido DESC;

-- Consulta 3: Top 5 produtos ativos mais caros do catálogo
SELECT 
    nome,
    codigo_barras,
    preco,
    quantidade_estoque
FROM produto
WHERE ativo = TRUE
ORDER BY preco DESC
LIMIT 5;

-- Consulta 4: Histórico de pagamentos aprovados mostrando os dados do pedido
SELECT 
    p.id_pedido,
    p.data_pedido,
    p.status_pedido,
    pg.forma_pagamento,
    pg.valor_pago,
    pg.data_pagamento
FROM pedido p
INNER JOIN pagamento pg ON p.id_pedido = pg.id_pedido
WHERE pg.status_pagamento = 'Aprovado'
ORDER BY pg.data_pagamento DESC;

-- Consulta 5: Detalhamento completo dos itens vendidos por cliente
SELECT 
    c.nome AS cliente,
    p.id_pedido,
    p.data_pedido,
    pr.nome AS produto,
    ip.quantidade,
    ip.preco_unitario,
    (ip.quantidade * ip.preco_unitario) AS subtotal_item
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
INNER JOIN produto pr ON ip.id_produto = pr.id_produto
ORDER BY p.id_pedido ASC, pr.nome ASC;

---Consulta 6: Produtos do catálogo que nunca foram vendidos
SELECT 
    pr.id_produto,
    pr.nome,
    pr.preco,
    pr.quantidade_estoque,
    pr.ativo
FROM produto pr
LEFT JOIN item_pedido ip ON pr.id_produto = ip.id_produto
WHERE ip.id_item_pedido IS NULL
ORDER BY pr.nome ASC;

--Consulta 7: Faturamento e quantidade de transações por forma de pagamento
SELECT 
    forma_pagamento,
    COUNT(id_pagamento) AS total_transacoes,
    SUM(valor_pago) AS receita_total,
    ROUND(AVG(valor_pago), 2) AS ticket_medio
FROM pagamento
WHERE status_pagamento = 'Aprovado'
GROUP BY forma_pagamento
ORDER BY receita_total DESC;

-- Consulta 8: Clientes com mais de um pedido realizado
SELECT 
    c.id_cliente,
    c.nome,
    c.email,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(p.valor_frete) AS total_frete_pago
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nome, c.email
HAVING COUNT(p.id_pedido) > 1
ORDER BY total_pedidos DESC;

-- Consulta 9: Produtos com preço acima da média do catálogo
SELECT 
    id_produto,
    nome,
    preco,
    ROUND((SELECT AVG(preco) FROM produto WHERE ativo = TRUE), 2) AS media_geral_catalogo
FROM produto
WHERE ativo = TRUE
  AND preco > (SELECT AVG(preco) FROM produto WHERE ativo = TRUE)
ORDER BY preco DESC;

-- Consulta 10: Clientes ativos que ainda não realizaram nenhum pedido
SELECT 
    id_cliente,
    nome,
    email,
    telefone
FROM cliente
WHERE ativo = TRUE
  AND id_cliente NOT IN (
      SELECT DISTINCT id_cliente 
      FROM pedido
  )
ORDER BY nome ASC;

--Consultas extra

--Consulta 11: Quais pedidos foram realizados por cada cliente e qual o valor total de cada pedido?
SELECT 
    c.id_cliente,
    c.nome AS cliente,
    p.id_pedido,
    p.data_pedido,
    p.status_pedido,
    SUM(ip.quantidade * ip.preco_unitario) AS subtotal_produtos,
    p.valor_frete,
    p.valor_desconto,
    (SUM(ip.quantidade * ip.preco_unitario) + p.valor_frete - p.valor_desconto) AS valor_total_pedido
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
GROUP BY c.id_cliente, c.nome, p.id_pedido, p.data_pedido, p.status_pedido, p.valor_frete, p.valor_desconto
ORDER BY c.nome ASC, p.data_pedido DESC;

--Consulta 12: Qual é o valor total das vendas realizadas no período de outubro a novembro de 2026?
SELECT 
    COUNT(DISTINCT p.id_pedido) AS total_pedidos_realizados,
    SUM(ip.quantidade * ip.preco_unitario) AS valor_bruto_produtos,
    SUM(DISTINCT p.valor_frete) AS total_frete,
    SUM(DISTINCT p.valor_desconto) AS total_descontos,
    (
        SELECT SUM(sub.total_pedido)
        FROM (
            SELECT 
                (SUM(ip2.quantidade * ip2.preco_unitario) + p2.valor_frete - p2.valor_desconto) AS total_pedido
            FROM pedido p2
            INNER JOIN item_pedido ip2 ON p2.id_pedido = ip2.id_pedido
            WHERE p2.data_pedido BETWEEN '2026-10-01 00:00:00' AND '2026-11-30 23:59:59'
              AND p2.status_pedido <> 'Cancelado'
            GROUP BY p2.id_pedido, p2.valor_frete, p2.valor_desconto
        ) sub
    ) AS valor_total_vendas_liquido
FROM pedido p
INNER JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
WHERE p.data_pedido BETWEEN '2026-10-01 00:00:00' AND '2026-11-30 23:59:59'
  AND p.status_pedido <> 'Cancelado';

-- Consulta 13: Consulta extra usando CTE (WITH), produtos vendidos em pedidos com pagamento aprovado, ordenados por unidades vendidas.
WITH vendas_por_produto AS (
    SELECT
        pr.id_produto,
        pr.nome,
        SUM(ip.quantidade) AS unidades_vendidas,
        SUM(ip.quantidade * ip.preco_unitario) AS faturamento
    FROM produto pr
    INNER JOIN item_pedido ip
        ON ip.id_produto = pr.id_produto
    INNER JOIN pedido p
        ON p.id_pedido = ip.id_pedido
    INNER JOIN pagamento pg
        ON pg.id_pedido = p.id_pedido
    WHERE pg.status_pagamento = 'Aprovado'
    GROUP BY pr.id_produto, pr.nome
)
SELECT
    id_produto,
    nome,
    unidades_vendidas,
    faturamento
FROM vendas_por_produto
ORDER BY unidades_vendidas DESC, nome;

-- Consulta 14: criar VIEW

CREATE OR REPLACE VIEW vw_resumo_pedidos AS
SELECT
    p.id_pedido,
    c.id_cliente,
    c.nome AS cliente,
    p.data_pedido,
    p.status_pedido,
    COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0) AS subtotal_produtos,
    p.valor_frete,
    p.valor_desconto,
    COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0)
        + p.valor_frete
        - p.valor_desconto AS valor_total_pedido
FROM pedido p
INNER JOIN cliente c
    ON c.id_cliente = p.id_cliente
LEFT JOIN item_pedido ip
    ON ip.id_pedido = p.id_pedido
GROUP BY
    p.id_pedido,
    c.id_cliente,
    c.nome,
    p.data_pedido,
    p.status_pedido,
    p.valor_frete,
    p.valor_desconto;


-- Consulta 15: Consulta da view criada anteriormente

SELECT *
FROM vw_resumo_pedidos
ORDER BY data_pedido DESC;

-- Consulta 16: Transãção com mais de uma operação. Insere um cliente temporário e um endereço associado. O ROLLBACK desfaz as duas operações

BEGIN;

INSERT INTO cliente (nome, cpf, email)
VALUES (
    'Cliente temporário da transação',
    '999.999.999-99',
    'transacao@joinshop.local'
)
ON CONFLICT DO NOTHING;

INSERT INTO endereco (
    id_cliente,
    cep,
    logradouro,
    numero,
    bairro,
    cidade,
    uf,
    tipo_endereco
)
SELECT
    id_cliente,
    '00000-000',
    'Rua de Teste',
    '0',
    'Centro',
    'Uberlândia',
    'MG',
    'Residencial'
FROM cliente
WHERE email = 'transacao@joinshop.local';

ROLLBACK;

-- Consulta 17: EXPLAIN ANALYZE - Explique a consulta que agrupa os produtos vendidos em pedidos com pagamento aprovado e calcula as unidades vendidas e o faturamento por produto

EXPLAIN ANALYZE
SELECT
    pr.id_produto,
    pr.nome,
    SUM(ip.quantidade) AS unidades_vendidas,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM produto pr
INNER JOIN item_pedido ip
    ON ip.id_produto = pr.id_produto
INNER JOIN pedido p
    ON p.id_pedido = ip.id_pedido
INNER JOIN pagamento pg
    ON pg.id_pedido = p.id_pedido
WHERE pg.status_pagamento = 'Aprovado'
GROUP BY pr.id_produto, pr.nome
ORDER BY unidades_vendidas DESC;
