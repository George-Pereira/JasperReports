CREATE DATABASE jasperExec
GO
USE jasperExec

CREATE TABLE fornecedor
(
	cod			INT		PRIMARY KEY,
	nome		VARCHAR(250),
	atividade	VARCHAR(250),
	telefone	CHAR(11)
)

CREATE TABLE produto
(
	cod				INT		PRIMARY KEY,
	nome			VARCHAR(250),
	valor_unit		DECIMAL(7,2),
	quant_estoque	INT,
	descricao		VARCHAR(200),
	cod_forn		INT,
	FOREIGN KEY (cod_forn) REFERENCES fornecedor(cod)	
)

CREATE TABLE cliente
(
	cod				INT PRIMARY KEY,
	nome			VARCHAR(250),
	endereco		VARCHAR(250),
	num_porta		INT,
	tel				CHAR(11),
	data_nasc		DATETIME
)

CREATE TABLE pedido
(
	cod_pedido			INT,
	cod_cliente			INT,
	cod_prod			INT,
	quant				INT,
	data_entrega		DATETIME,
	FOREIGN KEY(cod_cliente) REFERENCES cliente(cod),
	FOREIGN KEY(cod_prod) REFERENCES produto(cod),
	CONSTRAINT pk_pedido PRIMARY KEY (cod_pedido, cod_cliente, cod_prod)
)

CREATE FUNCTION fn_cabecalhoRelatorio(@cod_cli INT)
RETURNS @tabela TABLE
(
	cod_ped			INT,
	cod_client		INT,
	nome_cli		VARCHAR(250),
	end_cli			VARCHAR(250),
	prev_entrega	DATETIME,
	cod_pr			INT,
	nome_prod		VARCHAR(250),
	val_unit		DECIMAL(7,2),
	quant			INT,
	val_tot			DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @tabela VALUES
	(
		(SELECT ped.cod_pedido, cli.cod, cli.nome, cli.endereco + ', ' + CONVERT(VARCHAR, cli.num_porta) + ' Tel: ' + CONVERT(CHAR, cli.tel) AS info_cliente, ped.data_entrega, pro.cod, pro.nome, pro.valor_unit, ped.quant, valor_tot = (pro.valor_unit * ped.quant)  FROM pedido ped INNER JOIN cliente cli ON ped.cod_cliente = cli.cod INNER JOIN produto pro ON ped.cod_prod = pro.cod WHERE cli.cod = 33601)
	)
	RETURN
END