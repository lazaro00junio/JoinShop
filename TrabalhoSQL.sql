CREATE TABLE IF NOT EXISTS `CLIENTE` (
	`id_cliente` INTEGER AUTO_INCREMENT,
	`nome` VARCHAR(100) NOT NULL,
	`cpf` VARCHAR(14) NOT NULL UNIQUE,
	`email` VARCHAR(100) NOT NULL UNIQUE,
	`telefone` VARCHAR(20),
	`endereco` TEXT NOT NULL,
	PRIMARY KEY(`id_cliente`)
);


CREATE TABLE IF NOT EXISTS `PRODUTO` (
	`id_produto` INTEGER AUTO_INCREMENT,
	`nome` VARCHAR(100) NOT NULL,
	`descricao` TEXT,
	`preco` DECIMAL(10,2) NOT NULL CHECK(`preco` >= 0),
	`estoque` INTEGER NOT NULL CHECK(`estoque` >= 0),
	`codigo_barras` VARCHAR(50) UNIQUE,
	PRIMARY KEY(`id_produto`)
);


CREATE TABLE IF NOT EXISTS `PEDIDO` (
	`id_pedido` INTEGER AUTO_INCREMENT,
	`id_cliente` INTEGER NOT NULL,
	`data_pedido` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`valor_total` DECIMAL(10,2) NOT NULL DEFAULT 0.00 CHECK(`valor_total` >= 0),
	`status_pedido` VARCHAR(20) NOT NULL CHECK(`status_pedido` IN Aguardando Pagamento AND Pago AND Enviado AND Entregue AND Cancelado),
	PRIMARY KEY(`id_pedido`)
);


CREATE TABLE IF NOT EXISTS `ITEM_PEDIDO` (
	`id_item_pedido` INTEGER AUTO_INCREMENT,
	`id_pedido` INTEGER NOT NULL,
	`id_produto` INTEGER NOT NULL,
	`quantidade` INTEGER NOT NULL CHECK(`quantidade` > 0),
	`preco_unitario` DECIMAL(10,2) NOT NULL CHECK(`preco_unitario` >= 0),
	`valor_subtotal` DECIMAL(10,2),
	PRIMARY KEY(`id_item_pedido`)
);


CREATE TABLE IF NOT EXISTS `PAGAMENTO` (
	`id_pagamento` INTEGER AUTO_INCREMENT,
	`id_pedido` INTEGER NOT NULL,
	`forma_pagamento` VARCHAR(30) NOT NULL CHECK(`forma_pagamento` IN Cartão de Crédito AND PIX AND Boleto AND Cartão de Débito),
	`valor_pago` DECIMAL(10,2) NOT NULL CHECK(`valor_pago` > 0),
	`status_pagamento` VARCHAR(20) NOT NULL CHECK(`status_pagamento` IN Pendente AND Aprovado AND Recusado AND Estornado),
	`data_pagamento` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id_pagamento`)
);


CREATE TABLE IF NOT EXISTS `PRODUTO` (
	`id_produto` INTEGER AUTO_INCREMENT,
	`nome` VARCHAR(100) NOT NULL,
	`descricao` TEXT,
	`preco` DECIMAL(10,2) NOT NULL CHECK(`preco` >= 0),
	`codigo_barras` VARCHAR(50) UNIQUE,
	PRIMARY KEY(`id_produto`)
);


CREATE TABLE IF NOT EXISTS `ESTOQUE` (
	`id_estoque` INTEGER AUTO_INCREMENT,
	`id_produto` INTEGER NOT NULL UNIQUE,
	`quantidade_disponivel` INTEGER NOT NULL DEFAULT 0 CHECK(`quantidade_disponivel` >= 0),
	`data_ultima_atualizacao` DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY(`id_estoque`)
);


CREATE TABLE IF NOT EXISTS `ITEM_PEDIDO` (
	`id_item_pedido` INTEGER AUTO_INCREMENT,
	`id_pedido` INTEGER NOT NULL,
	`id_produto` INTEGER NOT NULL,
	`quantidade` INTEGER NOT NULL CHECK(`quantidade` > 0),
	`preco_unitario` DECIMAL(10,2) NOT NULL CHECK(`preco_unitario` >= 0),
	PRIMARY KEY(`id_item_pedido`)
);


ALTER TABLE `PEDIDO`
ADD FOREIGN KEY(`id_cliente`) REFERENCES `CLIENTE`(`id_cliente`)
ON UPDATE NO ACTION ON DELETE RESTRICT;
ALTER TABLE `ITEM_PEDIDO`
ADD FOREIGN KEY(`id_pedido`) REFERENCES `PEDIDO`(`id_pedido`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `ITEM_PEDIDO`
ADD FOREIGN KEY(`id_produto`) REFERENCES `PRODUTO`(`id_produto`)
ON UPDATE NO ACTION ON DELETE RESTRICT;
ALTER TABLE `PAGAMENTO`
ADD FOREIGN KEY(`id_pedido`) REFERENCES `PEDIDO`(`id_pedido`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `ESTOQUE`
ADD FOREIGN KEY(`id_produto`) REFERENCES `PRODUTO`(`id_produto`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `ITEM_PEDIDO`
ADD FOREIGN KEY(`id_produto`) REFERENCES `PRODUTO`(`id_produto`)
ON UPDATE NO ACTION ON DELETE RESTRICT;
