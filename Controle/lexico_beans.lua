dofile("../modelo/modelo_lexico.lua");

--[[
@Titulo: Selecionar sin�nimos do l�xico.
@Objetivo: Fornecer uma lista com todos os sino�nimos de um determinado l�xico.
@Contexto: O usu�rio escolhe um l�xico do menu lateral e clica na op��o alterar l�xico.
@Atores: browser e usu�rio.
@Recursos: modelo_lexico.lua.
]]--

function listar_sinonimos_lexico(id_projeto, nome_lexico)

--@Epis�dio 1: SELECIONAR SINONIMOS L�XICO
	lista_sinonimos, sinonimos = selecionar_sinonimos_lexico(id_projeto, nome_lexico)
	
--@Epis�dio 2: Retorna os sin�nimos
	return sinonimos;
end

--[[
@Titulo: Recuperar dados do l�xico
@Objetivo: Recuperar os dados de um l�xico
@Contexto: A p�gina alterar_lexico.lp  � acessada.
@Atores: browser e usu�rio.
@Recursos: modelo_lexico.lua.
]]--

function selecionar_dados_lexico(nome, id_projeto, formatado)
	
--Epis�dio 1: SELECIONAR L�XICO
	lexico_selecionado = selecionar_lexico(id_projeto, nome);
	
--Epis�dio 2: SELECIONAR SIN�NIMOS LEXICO
	lista_sinonimos, sinonimos = selecionar_sinonimos_lexico(id_projeto, nome);	
		
--Epis�dio 2: Se formatado � verdadeiro. O texto do l�xico selecionado � formatado. As ocorr�ncias de "\n" s�o substituidas por "<br>" para que as quebras de linha sejam visualizadas pelo usu�rio.

if (formatado) then
	lexico_selecionado[1]["NOME"] = string.gsub(lexico_selecionado[1]["NOME"],"\n","<br>");
	lexico_selecionado[1]["NOCAO"] = string.gsub(lexico_selecionado[1]["NOCAO"],"\n","<br>");
	lexico_selecionado[1]["IMPACTO"] = string.gsub(lexico_selecionado[1]["IMPACTO"],"\n","<br>");
	lexico_selecionado[1]["CLASSIFICACAO"] = string.gsub(lexico_selecionado[1]["CLASSIFICACAO"],"\n","<br>");
end


--Epis�dio3: Retorna os dados do l�xico selecionado	
	return lexico_selecionado, lista_sinonimos;


end


