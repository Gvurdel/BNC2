--Considerando as tabelas do trabalho de Multas: ex_motorista e ex_multa, faça:

-- Um procedimento o qual possa gerenciar as mensagens de erro fm_msg() o qual receba um tipo de erro e gere uma respectiva mensagem;

-- Crie um procedimento, chamado de  fm_lista(), no qual liste os motoristas (nome) e seu total de multas, caso o parametro sejam TODOS ou apenas de um CNH;

-- Monte um procedimento, chamado de fm_totalMultas(), no qual retorne o total de multas de cada motorista. Use na função fm_lista()

-- OBS: use o procedimento fm_msg() para que gere mensagens do tipo:

   -- -Motorista não cadastrado;

   -- -Motorista sem multas, etc

-- OK
create or replace function fm_lista(pCNH char(5)) returns void as
$$

declare

_motorista RECORD;
_totalMultaFn decimal(20,2) := 0;

begin

perform * from ex_motorista m where m.cnh = pCNH;

if not found and upper(pCNH) <> 'TODOS' then
	raise exception '%', fm_msg(1);
end if;

if upper(pCNH) <> 'TODOS' then
	 select * into _motorista from ex_motorista
	 where cnh = pCNH;
	 _totalMultaFn := fn_obter_total_multa(_motorista.cnh);
		
	if _motorista.nome <> '' and _totalMultaFn <> 0 then
		raise notice 'Nome: % - Total multas: %', rtrim(_motorista.nome), _totalMultaFn;		 
	else
		raise exception '%', fm_msg(2);
	end if;
else
	for _motorista in select * from ex_motorista motorista loop
	_totalMultaFn := fn_obter_total_multa(_motorista.cnh);
		if _motorista.nome <> '' and _totalMultaFn <> 0 then
			raise notice 'Nome: % - Total multas: %', rtrim(_motorista.nome), _totalMultaFn;
		else
			raise exception '%', fm_msg(3);
		end if;
	end loop;
end if;

end;

$$ language plpgsql;


-- OK   
create or replace function fm_msg(pErrorKey int) returns text as
$$

begin

if pErrorKey = 1 then
	return 'Motorista nao existe';
elsif pErrorKey = 2 then
	return 'Motorista nao possui multas';
elsif pErrorKey = 3 then
	return 'Nao existe multa para nenhum motorista';
end if;

end;

$$ language plpgsql;