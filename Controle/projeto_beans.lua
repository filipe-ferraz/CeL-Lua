dofile("../modelo/modelo_projeto.lua");

--[[
@Titulo: Montar menu de projetos.
@Objetivo: Fornecer uma lista com todos os projetos cadastrados para determinado usu�rio.
@Contexto: O menu de projetos da p�gina principal � atualizado.
@Atores: browser e usu�rio.
@Recursos: modelo_projeto.lua.
]]--

function carregar_projetos(id_usuario)

--@Epis�dio 1: SELECIONAR PROJETOS.
	projetos = selecionar_projetos(id_usuario);

	
	lista_de_projetos = "";
--@Epis�dio 2: percorre a lista de projetos retornados da sele��o, montando o menu e armazenando na variavel lista_de_projetos.		
	if(#projetos > 0) then
		for index, projeto in pairs(projetos) do
			lista_de_projetos = lista_de_projetos.."<option value="..projeto["ID_PROJETO"]..">";
			lista_de_projetos = lista_de_projetos..projeto["NOME"];
			lista_de_projetos = lista_de_projetos.."</option>";
		end
	end
	
--@Epis�dio 3: retorna o menu montado.
	return lista_de_projetos;
end

function selecionar_nome_projeto(id_projeto)

--@Epis�dio 1: SELECIONAR PROJETOS.
	projeto = selecionar_projeto(id_projeto);
	return projeto[1]["NOME"];
end

function colocar_links_texto(id_projeto, texto, tipo)
	texto_com_links = coloca_links(id_projeto, texto, tipo);
end 
