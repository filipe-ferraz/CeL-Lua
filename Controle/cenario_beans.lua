dofile("../modelo/modelo_cenario.lua");

--[[
@Titulo: Exibir dados de um cen�rio
@Objetivo: Fornecer uma lista com todos os sino�nimos de um determinado l�xico.
@Contexto: O usu�rio escolhe um l�xico do menu lateral e clica na op��o alterar l�xico.
@Atores: browser e usu�rio.
@Recursos: modelo_lexico.lua.
]]--

function selecionar_dados_cenario(titulo, id_projeto, formatado)

--Epis�dio 1: SELECIONAR CEN�RIO
	cenario_selecionado = selecionar_cenario(id_projeto, titulo);
	
--Epis�dio 2: Se formatado � verdadeiro. O texto do cen�rio selecionado � formatado. As ocorr�ncias de "\n" s�o substituidas por "<br>" para que as quebras de linha sejam visualizadas pelo usu�rio.
if (formatado) then
	cenario_selecionado[1]["TITULO"] = string.gsub(cenario_selecionado[1]["TITULO"],"\n","<br>");
	cenario_selecionado[1]["OBJETIVO"] = string.gsub(cenario_selecionado[1]["OBJETIVO"],"\n","<br>");
	cenario_selecionado[1]["CONTEXTO"] = string.gsub(cenario_selecionado[1]["CONTEXTO"],"\n","<br>");
	cenario_selecionado[1]["ATORES"] = string.gsub(cenario_selecionado[1]["ATORES"],"\n","<br>");
	cenario_selecionado[1]["RECURSOS"] = string.gsub(cenario_selecionado[1]["RECURSOS"],"\n","<br>");
	cenario_selecionado[1]["EPISODIOS"] = string.gsub(cenario_selecionado[1]["EPISODIOS"],"\n","<br>");
	cenario_selecionado[1]["EXCECAO"] = string.gsub(cenario_selecionado[1]["EXCECAO"],"\n","<br>");
end
--Epis�dio3: Retorna os dados do cen�rio selecionado	
	return cenario_selecionado;


end


