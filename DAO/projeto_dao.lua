dofile("../bd/conexao_bd.lua");

--[[
@Titulo: Inserir projeto no banco de dados.
@Objetivo:Inserir os dados do projeto no banco de dados.
@Contexto: A camada modelo chama a função inserir_projeto_bd.
@Atores: usuário.
@Recursos: conexao_bd.lua.
]]--


function inserir_projeto_bd(nome, descricao, data, id_usuario)

--@Episódio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Episódio 2: Montar query de inserção com os valores passados por parâmetro.
	local stmt = ("insert into projeto (nome, descricao, data_criacao, usuario)" 
		.."values (\""..nome.."\",\""..descricao.."\",\""..data.."\",\""..id_usuario.."\")");

--@Episódio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)

--@Episódio 4: Tratamento de eventuais erros.
	if not cursor then
	        error (erro.." SQL = [=["..stmt.."]=]")
	end

--@Episódio 5: Fechar a conexão
	conexao:close(); 
	return true;
	
end

--[[
@Titulo: Remover projeto do banco de dados.
@Objetivo:Remover os dados do projeto do banco de dados.
@Contexto: A camada modelo chama a função remover_projeto.
@Atores: usuário.
@Recursos: conexao_bd.lua.
]]--

function remover_projeto(id_projeto)

--@Episódio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Episódio 2: Montar query de remoção com os valores passados por parâmetro.
	local stmt = ("delete from projeto where id_projeto = \""..id_projeto.."\"");
	
--@Episódio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Episódio 4: Tratamento de eventuais erros.
	if not cursor then
	        error (erro.." SQL = [=["..stmt.."]=]")
	end

--@Episódio 5: Fechar a conexão
	conexao:close(); 	
	return true;

end

--[[
@Titulo: Selecionar  projeto do banco de dados pelo id do projeto.
@Objetivo:Recuperar os dados de um determinado projeto do banco de dados usando o id do projeto
@Contexto: A camada modelo chama a função selecionar_projeto_bd.
@Atores: usuário.
@Recursos: conexao_bd.lua.
]]--

function selecionar_projeto_bd(id_projeto)

--@Episódio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Episódio 2: Montar query de seleção utilizando o id do projeto.
	local stmt = ("select * from projeto where id_projeto = \""..id_projeto.."\"");
	
--@Episódio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Episódio 4: Tratamento de eventuais erros.
	if not cursor then
		error (erro.." SQL = [=["..stmt.."]=]")
	end
	
--@Episódio 5: Armazenar o resultado da consulta em uma tabela.
	linha = cursor:fetch ({}, "a");
	tabela = {};
	while linha do
		table.insert(tabela,linha);
		linha = cursor:fetch ({}, "a");
	end
	
--@Episódio 6: Fechar a conexão
	conexao:close(); 	
--@Episódio 7: Retornar tabela com os resultados	
	return tabela;	
	
end



--[[
@Titulo: Selecionar  projetos do banco de dados.
@Objetivo:Selecionar todos os projetos pertencentes a um determinado usuário do banco de dados
@Contexto: A camada modelo chama a função selecionar_projetos_bd.
@Atores: usuário.
@Recursos: conexao_bd.lua.
]]--

function selecionar_projetos_bd (id_usuario)

--@Episódio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Episódio 2: Montar query de seleção com os valores passados por parâmetro.
	local stmt = ("select * from projeto where usuario= \""..id_usuario.."\"");
	
--@Episódio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Episódio 4: Tratamento de eventuais erros.
	if not cursor then
		error (erro.." SQL = [=["..stmt.."]=]")
	end
	
--@Episódio 5: Armazenar o resultado da consulta em uma tabela.
	linha = cursor:fetch ({}, "a");
	tabela = {};
	while linha do
		table.insert(tabela,linha);
		linha = cursor:fetch ({}, "a");
	end
	
--@Episódio 6: Fechar a conexão
	conexao:close(); 	
--@Episódio 7: Retornar tabela com os resultados	
	return tabela;	

end
