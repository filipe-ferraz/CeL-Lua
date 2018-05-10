dofile("../bd/conexao_bd.lua");

--[[
@Titulo: Inserir l�xico no banco de dados.
@Objetivo:Inserir os dados do l�xico no banco de dados.
@Contexto: A camada modelo chama a fun��o inserir_lexico_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--


function inserir_lexico_bd (nome, nocao, impacto, classificacao, projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de inser��o com os valores passados por par�metro.
	local stmt = ("insert into lexico values (\""..nome.."\",\""..nocao.."\",\""..impacto.."\",\""
		..classificacao.."\",\""..projeto.."\")");

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
@Titulo: Remover l�xico do banco de dados.
@Objetivo:Remover os dados do l�xico do banco de dados.
@Contexto: A camada modelo chama a fun��o remover_lexico_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--


function remover_lexico_bd(id_projeto, nome)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de remo��o com os valores passados por par�metro.
	local stmt = ("delete from lexico where nome = \""..nome.."\" and projeto = \""..id_projeto.."\"");

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
@Titulo: Remover sinonimos do banco de dados.
@Objetivo:Remover os sinonimos de um determinado l�xico do banco de dados.
@Contexto: A camada modelo chama a fun��o remover_sinonimos_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function remover_sinonimos_bd(nome, id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de remo��o com os valores passados por par�metro.
	local stmt = ("delete from sinonimo where lexico = \""..nome.."\" and projeto = \""..id_projeto.."\"");
	
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
@Titulo: Inserir sin�nimo no banco de dados.
@Objetivo:Inserir os dados do sin�nimo no banco de dados.
@Contexto: A camada modelo chama a fun��o inserir_sinonimo_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function inserir_sinonimo_bd (sinonimo, nome_lexico, id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de inser��o com os valores passados por par�metro.
	local stmt = ("insert into sinonimo values (\""..sinonimo.."\",\""..nome_lexico.."\",\""..id_projeto.."\")");

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
@Titulo: Selecionar l�xico do banco de dados
@Objetivo:Selecionar um l�xico do banco de dados.
@Contexto: A camada modelo chama a fun��o selecionar_lexico_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--


function selecionar_lexico_bd(id_projeto, nome_lexico)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();

--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from lexico where nome = \""..nome_lexico.."\" and projeto = \""..id_projeto.."\"");
	
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
--@Epis�dio 6: Fecha a conex�o.	
	conexao:close(); 
	
--@Epis�dio 7: Retornar tabela com o resultado.
	return tabela;
end

--[[
@Titulo: Selecionar todos os l�xicos do banco de dados
@Objetivo:Selecionar todos os l�xicos pertencentes a um projeto
@Contexto: A camada modelo chama a fun��o selecionar_todos_lexicos_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_todos_lexicos_bd(id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();
	
--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from lexico where projeto = \""..id_projeto.."\"");
	
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
--@Epis�dio 5: Fecha a conex�o.
	conexao:close(); 

--@Epis�dio 7: Retornar tabela com o resultado.
	return tabela;
end

--[[
@Titulo: Selecionar sin�nimo do banco de dados
@Objetivo:Selecionar um sin�nimo do banco de dados
@Contexto: A camada modelo chama a fun��o selecionar_sinonimo_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_sinonimos_bd(nome_lexico, id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();

--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from sinonimo where nome = \""..nome_lexico.."\" and projeto = \""..id_projeto.."\"");
			
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

--@Epis�dio 5: Fecha a conex�o.
	conexao:close(); 
	
--@Epis�dio 7: Retornar tabela com o resultado.
	return tabela;

end

--[[
@Titulo: Selecionar sin�nimos do l�xico do banco de dados
@Objetivo:Selecionar os sin�nimos de um l�xico especifico do banco de dados
@Contexto: A camada modelo chama a fun��o selecionar_sinonimos_lexico_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_sinonimos_lexico_bd(nome_lexico, id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();

--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from sinonimo where lexico = \""..nome_lexico.."\" and projeto = \""..id_projeto.."\"");
	
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
	
--@Epis�dio 5: Fecha a conex�o.
	conexao:close(); 

--@Epis�dio 7: Retornar tabela com o resultado.
	return tabela;

end


--[[
@Titulo: Selecionar sin�nimos de um projeto do banco de dados
@Objetivo:Selecionar os sin�nimos dos l�xicos de um projeto especifico do banco de dados
@Contexto: A camada modelo chama a fun��o selecionar_sinonimos_projeto_bd.
@Atores: usu�rio.
@Recursos: conexao_bd.lua.
]]--

function selecionar_sinonimos_projeto_bd(id_projeto)

--@Epis�dio 1: CONECTAR AO BANCO DE DADOS.
	local conexao = conectar_bd();

--@Epis�dio 2: Montar query de sele��o com os valores passados por par�metro.
	local stmt = ("select * from sinonimo where projeto = "..id_projeto);
	
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
	
--@Epis�dio 5: Fecha a conex�o.
	conexao:close(); 

--@Epis�dio 7: Retornar tabela com o resultado.
	return tabela;

end



