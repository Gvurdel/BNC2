create table Xproduto

(codproduto   int   not null,
 descricaoproduto  varchar(50)  not null,
 unidade   char(2)   not null,
 preco    float   not null,
 primary key (codproduto)); 
 
 create table Xcliente
 
 (codcliente   int   not null,
  cliente    varchar(50)  not null,
  cpf    char(11)  not null,
  endereco   char(30)  not null,
  primary key (codcliente)); 
  
  create table Xtipospagamento
  
  (codtppagamento  int   not null,
   descricaotppagamento varchar(20)  not null,
   primary key (codtppagamento));
   
   create table Xvenda
   
   (nnf     int     not null,
	dtvenda    date      not null,
	codcliente    int     not null,
	codtppagamento   int     not null,
	vlvenda    float     not null,
	primary key (nnf, dtvenda),
	foreign key (codcliente) references  Xcliente,
	foreign key (codtppagamento) references Xtipospagamento);
	
	create table Xitensvenda 
	
	(nnf     int    not null,
	 dtvenda    date    not null,
	 codproduto    int    not null, 
	 qtde     float     not null, 
	 
	 primary key (nnf, dtvenda, codproduto), 
	 foreign key (nnf, dtvenda) references Xvenda,
	 foreign key (codproduto) references Xproduto); 
	 
	 insert into Xproduto values (1, 'Coca Cola', 'lt', 1.20); 
	 insert into Xproduto values (2, 'Presunto Sadia', 'kg', 5.40);
	 insert into Xproduto values (3, 'Sabonete Palmolive', 'un', 0.65); 
	 insert into Xproduto values (4, 'Shampoo Colorama', 'un', 2.60); 
	 insert into Xproduto values (5, 'Cerveja Skol', 'gf', 0.99);  
	 insert into Xcliente values (1, 'Joao da Silva', '123456789', 'Rua Andradas, 250');
	 insert into Xcliente values (2, 'Maria do Rosario', '26547899', 'Rua Lima e Silva, 648');
	 insert into Xcliente values (3, 'Paulo Silveira', '8963254', 'Rua Plinio Brasil Milano, 980'); 
	 insert into Xcliente values (4, 'Rosa Aparecida dos Santos', '5896332123', 'Av Ipiranga, 8960');  
	 insert into Xtipospagamento values (1, 'Cheque'); 
	 insert into Xtipospagamento values (2, 'Dinheiro'); 
	 insert into Xtipospagamento values (3, 'Crediario'); 
	 insert into Xvenda values (1, '20/04/2002', 1, 1, 15.00); 
	 insert into Xvenda values (2, '20/04/2002', 2, 1, 7.50);
	 insert into Xvenda values (1, '25/04/2002', 3, 2, 7.90); 
	 insert into Xvenda values (1, '30/04/2002', 3, 2, 8.50);  
	 insert into Xitensvenda values (1, '20/04/2002', 1, 1); 
	 insert into Xitensvenda values (1, '20/04/2002', 2, 2); 
	 insert into Xitensvenda values (2, '20/04/2002', 1, 3); 
	 insert into Xitensvenda values (2, '20/04/2002', 2, 2); 
	 insert into Xitensvenda values (2, '20/04/2002', 4, 4); 
	 insert into Xitensvenda values (1, '25/04/2002', 3, 9);
	 insert into Xitensvenda values (1, '30/04/2002', 3, 7); 
	 
	 select * from Xproduto
	 
	 
-- Selecionar o nome do cliente e quantidade de produtos comprados, somente para clientes que compraram Coca Cola. 

SELECT Xcliente.cliente, SUM(Xitensvenda.qtde) AS qtde
FROM Xcliente
INNER JOIN Xvenda ON Xcliente.codcliente = Xvenda.codcliente
INNER JOIN Xitensvenda ON Xvenda.nnf = Xitensvenda.nnf AND Xvenda.dtvenda = Xitensvenda.dtvenda
INNER JOIN Xproduto ON Xitensvenda.codproduto = Xproduto.codproduto
WHERE Xproduto.descricaoproduto = 'Coca Cola'
GROUP BY Xcliente.cliente;


--Selecionar o nome do cliente e o valor total comprado por ele. 

SELECT c.cliente, SUM(v.vlvenda) AS sum
FROM Xcliente c
INNER JOIN Xvenda v ON c.codcliente = v.codcliente
GROUP BY c.cliente;

-- Selecionar a descrição e o maior preço de produto vendido. 

SELECT p.descricaoproduto, MAX(p.preco) AS max
FROM Xproduto p
INNER JOIN Xitensvenda iv ON p.codproduto = iv.codproduto
GROUP BY p.descricaoproduto;

--Selecionar o nome do cliente e descrição do tipo de pagamento utilizado nas vendas.

SELECT c.cliente, tp.descricaotppagamento AS descricaotppagamento
FROM Xcliente c
INNER JOIN Xvenda v ON c.codcliente = v.codcliente
INNER JOIN Xtipospagamento tp ON v.codtppagamento = tp.codtppagamento;

--Selecionar o nome do cliente, nnf, data da venda, descrição do tipo de pagamento, descrição do produto e quantidade vendida dos itens vendidos. 

SELECT c.cliente, v.nnf, v.dtvenda, tp.descricaotppagamento AS descricaotppagamento, p.descricaoproduto, iv.qtde
FROM Xcliente c
INNER JOIN Xvenda v ON c.codcliente = v.codcliente
INNER JOIN Xtipospagamento tp ON v.codtppagamento = tp.codtppagamento
INNER JOIN Xitensvenda iv ON v.nnf = iv.nnf AND v.dtvenda = iv.dtvenda
INNER JOIN Xproduto p ON iv.codproduto = p.codproduto;

-- Selecionar a média de preço dos produtos vendidos.

SELECT CAST(AVG(p.preco) AS DECIMAL(10,3)) AS avg
FROM Xproduto p
INNER JOIN Xitensvenda iv ON p.codproduto = iv.codproduto;

-- Selecionar o nome do cliente e a descrição dos produtos comprados por ele. Não repetir os dados (distinct) 

SELECT DISTINCT c.cliente, p.descricaoproduto
FROM Xcliente c
INNER JOIN Xvenda v ON c.codcliente = v.codcliente
INNER JOIN Xitensvenda iv ON v.nnf = iv.nnf AND v.dtvenda = iv.dtvenda
INNER JOIN Xproduto p ON iv.codproduto = p.codproduto;

-- Selecionar a descrição do tipo de pagamento, e a maior data de venda que utilizou esse tipo de pagamento. 
-- Ordenar a consulta pela descrição do tipo de pagamento. 

SELECT tp.descricaotppagamento, MAX(v.dtvenda) AS max
FROM Xtipospagamento tp
INNER JOIN Xvenda v ON tp.codtppagamento = v.codtppagamento
GROUP BY tp.descricaotppagamento
ORDER BY tp.descricaotppagamento;

-- Selecionar a data da venda e a média da quantidade de produtos vendidos.
-- Ordenar pela data da venda decrescente. 

SELECT v.dtvenda, AVG(iv.qtde) AS media_quantidade_vendida
FROM Xvenda v
INNER JOIN Xitensvenda iv ON v.nnf = iv.nnf AND v.dtvenda = iv.dtvenda
GROUP BY v.dtvenda
ORDER BY v.dtvenda DESC;

-- Selecionar a descrição do produto e a média de quantidades vendidas do produto. 
-- Somente se a média for superior a 4 

SELECT p.descricaoproduto, AVG(iv.qtde) AS avg
FROM Xproduto p
INNER JOIN Xitensvenda iv ON p.codproduto = iv.codproduto
GROUP BY p.descricaoproduto
HAVING AVG(iv.qtde) > 4;





	 