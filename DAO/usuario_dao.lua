dofile("../bd/conexao_bd.lua");
--[[
@Titulo: Inserir usu�rio no banco de dados.
@Objetivo:Inserir os dados do usu�rio no banco de dados.
@Contexto: A camada modelo chama a fun��o inserir_usuario_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--
function inserir_usuario_bd (nome, sobrenome, email, instituicao, login, senha)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de inser��o com os valores passados por par�metro.
	local stmt = ("insert into usuario (nome, sobrenome, email, instituicao, login, senha)" 
		.."values (\""..nome.."\",\""..sobrenome.."\",\""..email.."\",\""..instituicao.."\",\""..login.."\",\""..senha.."\")");

--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)

--@Epis�dio 4: Tratamento de eventuais erros.
	if not cursor then
	        error (erro.." SQL = [=["..stmt.."]=]")
	end
--@Epis�dio 5: Fechar a conex�o
	conexao:close(); 	
end 
--[[
@Titulo: Selecionar usu�rio no banco de dados.
@Objetivo:Dado o login, recuperar os dados do usu�rio do banco de dados
@Contexto: A camada modelo chama a fun��o selecionar_usuario_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--
function selecionar_usuario_bd (login)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();

--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from usuario where login = \""..login.."\"");
	
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
@Titulo: Remover usuario do banco de dados.
@Objetivo:Dado o login, remover os dados do usu�rio do banco de dados.
@Contexto: A camada modelo chama a fun��o remover_usuario_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function remover_usuario_bd (id_usuario)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_db();
	
--@Epis�dio 2: Montar query de exclus�o com os valores passados por par�metro.
	local stmt = ("delete from usuario where id = \""..id_usuario.."\"");

--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Epis�dio 4: Tratamento de eventuais erros.
	if not cursor then
	        error (erro.." SQL = [=["..stmt.."]=]")
	end
--@Epis�dio 7: Fechar a conex�o
	conexao:close(); 
end

 