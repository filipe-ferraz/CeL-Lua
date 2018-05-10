dofile("../bd/conexao_bd.lua");

--[[
@Titulo: Inserir projeto no banco de dados.
@Objetivo:Inserir os dados do projeto no banco de dados.
@Contexto: A camada modelo chama a fun��o inserir_projeto_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--


function inserir_projeto_bd(nome, descricao, data, id_usuario)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de inser��o com os valores passados por par�metro.
	local stmt = ("insert into projeto (nome, descricao, data_criacao, usuario)" 
		.."values (\""..nome.."\",\""..descricao.."\",\""..data.."\",\""..id_usuario.."\")");

--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)

--@Epis�dio 4: Tratamento de eventuais erros.
	if not cursor then
	        error (erro.." SQL = [=["..stmt.."]=]")
	end

--@Epis�dio 5: Fechar a conex�o
	conexao:close(); 
	return true;
	
end

--[[
@Titulo: Remover projeto do banco de dados.
@Objetivo:Remover os dados do projeto do banco de dados.
@Contexto: A camada modelo chama a fun��o remover_projeto.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function remover_projeto(id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de remo��o com os valores passados por par�metro.
	local stmt = ("delete from projeto where id_projeto = \""..id_projeto.."\"");
	
--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Epis�dio 4: Tratamento de eventuais erros.
	if not cursor then
	        error (erro.." SQL = [=["..stmt.."]=]")
	end

--@Epis�dio 5: Fechar a conex�o
	conexao:close(); 	
	return true;

end

--[[
@Titulo: Selecionar  projeto do banco de dados pelo id do projeto.
@Objetivo:Recuperar os dados de um determinado projeto do banco de dados usando o id do projeto
@Contexto: A camada modelo chama a fun��o selecionar_projeto_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_projeto_bd(id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de sele��o utilizando o id do projeto.
	local stmt = ("select * from projeto where id_projeto = \""..id_projeto.."\"");
	
--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Epis�dio 4: Tratamento de eventuais erros.
	if not cursor then
		error (erro.." SQL = [=["..stmt.."]=]")
	end
	
--@Epis�dio 5: Armazenar o resultado da consulta em uma tabela.
	linha = cursor:fetch ({}, "a");
	tabela = {};
	while linha do
		table.insert(tabela,linha);
		linha = cursor:fetch ({}, "a");
	end
	
--@Epis�dio 6: Fechar a conex�o
	conexao:close(); 	
--@Epis�dio 7: Retornar tabela com os resultados	
	return tabela;	
	
end



--[[
@Titulo: Selecionar  projetos do banco de dados.
@Objetivo:Selecionar todos os projetos pertencentes a um determinado usu�rio do banco de dados
@Contexto: A camada modelo chama a fun��o selecionar_projetos_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_projetos_bd (id_usuario)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from projeto where usuario= \""..id_usuario.."\"");
	
--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Epis�dio 4: Tratamento de eventuais erros.
	if not cursor then
		error (erro.." SQL = [=["..stmt.."]=]")
	end
	
--@Epis�dio 5: Armazenar o resultado da consulta em uma tabela.
	linha = cursor:fetch ({}, "a");
	tabela = {};
	while linha do
		table.insert(tabela,linha);
		linha = cursor:fetch ({}, "a");
	end
	
--@Epis�dio 6: Fechar a conex�o
	conexao:close(); 	
--@Epis�dio 7: Retornar tabela com os resultados	
	return tabela;	

end
