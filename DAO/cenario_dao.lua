dofile("../bd/conexao_bd.lua");

--[[
@Titulo: Inserir cen�rio no banco de dados.
@Objetivo:Inserir os dados do cen�rio no banco de dados.
@Contexto: A camada modelo chama a fun��o inserir_cenario_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function inserir_cenario_bd(titulo, objetivo, contexto, atores, recursos, episodios, excecao, data, projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de inser��o com os valores passados por par�metro.
	local stmt = ("insert into cenario values (\""..titulo.."\",\""..objetivo.."\",\""..contexto.."\",\""
	..atores.."\",\""..recursos.."\",\""..episodios.."\",\""..excecao.."\",\""..data.."\",\""..projeto.."\")");
	
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
@Titulo: Remover cen�rio do banco de dados.
@Objetivo:Remover os dados do cen�rio do banco de dados.
@Contexto: A camada modelo chama a fun��o remover_cenario_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function remover_cenario_bd(id_projeto, titulo)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de remo��o com os valores passados por par�metro.
	local stmt = ("delete from cenario where titulo = \""..titulo.."\" and projeto = \""..id_projeto.."\"");
	
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
@Titulo: Selecionar cen�rio do banco de dados
@Objetivo:Selecionar um cen�rio do banco de dados.
@Contexto: A camada modelo chama a fun��o selecionar_cenario_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_cenario_bd(id_projeto, titulo)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from cenario where titulo = \""..titulo.."\" and projeto = \""..id_projeto.."\"");
	
--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Epis�dio 4: Tratamento de eventuais erros.
	if not cursor then
		error (erro.." SQL = [=["..stmt.."]=]")
	end
--@Epis�dio 5: Armazena os resultados da sele��o em uma tabela.
	linha = cursor:fetch ({}, "a");
	tabela = {};
	while linha do
		table.insert(tabela,linha);
		linha = cursor:fetch ({}, "a");
	end
	
--@Epis�dio 6: Fecha a conex�o	
	conexao:close(); 

--@Epis�dio 7: Retorna tabela com o resultado.
	return tabela;
end

--[[
@Titulo: Selecionar todos os cen�rio do banco de dados.
@Objetivo: Selecionar todos os cen�rio de um determinado projeto.
@Contexto: A camada modelo chama a fun��o selecionar_todos_cenarios_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_todos_cenarios_bd(id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from cenario where projeto = \""..id_projeto.."\"");
	
--@Epis�dio 3: Executar a query.
	local cursor, erro = conexao:execute (stmt)
	
--@Epis�dio 4: Tratamento de eventuais erros	
	if not cursor then
		error (erro.." SQL = [=["..stmt.."]=]")
	end
--@Epis�dio 5: Armazena os resultados da sele��o em uma tabela	
	linha = cursor:fetch ({}, "a");
	tabela = {};
	while linha do
		table.insert(tabela,linha);
		linha = cursor:fetch ({}, "a");
	end
	
--@Epis�dio 6: Fechar a conex�o	
	conexao:close(); 

--@Epis�dio 7: Retornar tabela com o resultado	
	return tabela;
end
