create  table produto
(cod_prod integer not null,
nome char(30) not null,
preco  float not null,
categoria char(20) not null,
primary key (cod_prod));


create table cliente
(cod_cli char(10) not null,
nome char(40) not null,
cidade char(20) not null,
uf char(2) not null,
telefone char(20),
status char(05) not null,
limite float not null,
primary key (cod_cli));


create table pedido
(nro_ped char(10) not null,
data_elab date not null,
data_ent date,
cod_cli char(10) not null,
primary key (nro_ped),
foreign key (cod_cli) references cliente);

create table movimento
(nro_ped char(10) not null,
cod_prod integer not null,
qtde integer not null,
total_mov float not null,
primary key (nro_ped, cod_prod),
foreign key (nro_ped) references pedido,
foreign key (cod_prod) references produto);

alter table pedido add total_ped float;

create  index Ch_Pr_Mov on movimento 
(qtde);

insert into cliente values ('c1','Super Merco', 'Porto Alegre',
'RS', '3308990','bom',400);
insert into cliente values ('c2','Shop Ltda', 'Canoas',
'RS', null,'otimo',1500);
insert into cliente values ('c3','Cia Limpar', 'Porto Alegre',
'RS', '3328791','medio',800);
insert into cliente values ('c4','Clean Ltda', 'Canoas',
'RS', '4776742','otimo',2300);

insert into produto values (1, 'OMO' ,2.65,'sabão');
insert into produto values (2,'Pinho Sol', 1.34, 'desinfetante');
insert into produto values (3,'Minerva', 1.98, 'sabão');
insert into produto values (4,'Confort', 1.54, 'amaciante');

insert into pedido values ('ped1','13/06/1997','15/06/1997','c2',null);
insert into pedido values ('ped2','15/06/1997','20/07/1997','c1',null);
insert into pedido values ('ped3','15/06/1997','19/07/1997','c4',null);

insert into movimento values('ped1',1,20,53.00);
insert into movimento values('ped1',3,15,29.70);
insert into movimento values('ped1',4,10,15.40);
insert into movimento values('ped2',4,12,18.48);
insert into movimento values('ped2',3,10,19.80);
insert into movimento values('ped3',1,15,39.75);

select * from cliente limit 2

select * from movimento
where nro_ped = 'ped1'
and qtde > 10

select * from pedido, cliente, movimento, produto
where pedido.cod_cli = cliente.cod_cli and 
pedido.nro_ped = movimento.nro_ped and 
produto.cod_prod = movimento.cod_prod and
cidade = 'Porto Alegre'

select * from cliente c
inner join pedido on (pedido.cod_cli = c.cod_cli)
inner join movimento on (pedido.nro_ped = movimento.nro_ped)
inner join produto on (produto.cod_prod = movimento.cod_prod)
where c.cidade = 'Porto Alegre'

select cast(sum(preco) as decimal(10,2))
from produto







create table funcionario
(codfunc varchar(10) not null,
nome char(50) not null,
codgerente varchar(10) not null ,
primary key (codfunc),
foreign key (codgerente) references funcionario);

insert into funcionario values ('F01', 'SEFORA', 'F02')
insert into funcionario values ('F02', 'DEBORA', 'F02')
insert into funcionario values ('F03', 'ADAM', 'F02')
insert into funcionario values ('F04', 'JOHN', 'F04')
update funcionario set codgerente = 'F04'
where codfunc = 'F02'

select * from funcionario 

--Excluir tabela

drop table funcionario

-- Mostre o nome do gerente e de seus funcionarios

select g.nome, f.nome from funcionario f, funcionario g
where g.codfunc = f.codgerente
and g.nome != f.nome


select count(*) from produto
select count(*) from cliente


select categoria, count(*) as qtde,
cast(sum(preco) as decimal(10,2)) as soma,
cast(avg(preco) as decimal(10,2)) as media,
min(preco) as menor,
max(preco) as maior
from produto
group by categoria
having count(*) > 1

select nro_ped, pedido.cod_cli,
nome, cliente.cod_cli
from pedido, cliente
where pedido.cod_cli = cliente.cod_cli


select nro_ped, pedido.cod_cli 
from pedido
where exists (select * from cliente
			  where pedido.cod_cli = cliente.cod_cli)
			  
			  
select nome, cod_cli 
from cliente
where exists (select * from pedido
			 where pedido.cod_cli = cliente.cod_cli)
			 
			 
select nome, cod_cli 
from cliente
where cod_cli in (select cod_cli from pedido)
			 
			 
select nome, total.categoria, soma
from produto,
(select categoria, sum(preco) as soma from produto
group by categoria) Total
where produto.categoria = total.categoria


CREATE VIEW v_TotalPedido AS
SELECT p.cod_cli, m.nro_ped, SUM(m.total_mov) AS total_pedido
FROM pedido p
JOIN movimento m ON p.nro_ped = m.nro_ped
GROUP BY p.cod_cli, m.nro_ped;

CREATE OR REPLACE FUNCTION atualizarTotalPedido(codigo_cliente char(10))
RETURNS void AS
$$
BEGIN
    UPDATE pedido p
    SET total_ped = v.total_pedido
    FROM v_TotalPedido v
    WHERE p.nro_ped = v.nro_ped
    AND p.cod_cli = codigo_cliente;
END;
$$
LANGUAGE sql;


			  