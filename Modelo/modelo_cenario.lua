dofile("../dao/cenario_dao.lua");
require("md5.core");

--[[
@Titulo: Cadastrar cen�rio.
@Objetivo: Cadastrar cen�rio no sistema.
@Contexto: A camada controle chama a fun��o cadastrar_cenario.
@Atores: browser e usu�rio.
@Recursos: cenario_dao.lua.
]]--

function cadastrar_cenario(titulo, objetivo, contexto, atores, recursos, episodios, excecao, projeto)

--@Epis�dio 1: Obt�m do sistema a data em que esta sendo feito o cadastro.
	data = os.date("%Y-%m-%d %H:%M:%S"); 
	
--@Epis�dio 2: INSERIR CEN�RIO NO BANCO DE DADOS
	resultado = inserir_cenario_bd(titulo, objetivo, contexto, atores, recursos, episodios, excecao, data, projeto);
	
--@Epis�dio 2: Retornar o resultado da inser��o.
	return resultado;

end

--[[
@Titulo: Remover cen�rio.
@Objetivo: Remover cen�rio do sistema.
@Contexto: A camada controle chama a fun��o remover_cenario.
@Atores: browser e usu�rio.
@Recursos: cenario_dao.lua.
]]--


function remover_cenario(id_projeto, titulo)

--@Epis�dio 1: REMOVER CENARIO DO BANCO DE DADOS .
	removido = remover_cenario_bd(id_projeto, titulo);
	
--@Epis�dio 2: Retorna resultado da remo��o.
	return removido;

end

--[[
@Titulo: Checar cen�rio.
@Objetivo: Verificar se um cen�rio j� esta cadastrado no banco de dados.
@Contexto: A camada controle chama a fun��o checar_cenario.
@Atores: browser e usu�rio.
@Recursos: cenario_dao.lua.
]]--



function checar_cenario(id_projeto, titulo)

--@Epis�dio 1: SELECIONAR CEN�RIO DO BANCO DE DADOS 
	cenarios = selecionar_cenario_bd(id_projeto, titulo);

--@Epis�dio 2: Se nenhum cen�rio for enontrado retorna false, sen�o retorna true.	
	if (#cenarios == 0) then
		return false;
	else 	
		return true;
	end
	
	return false;
		
end

--[[
@Titulo:  Selecionar todos os cen�rios
@Objetivo: Selecionar todos os cen�rios de um determinado projeto.
@Contexto: A camada controle chama a fun��o selecionar_todos_cenarios.
@Atores: browser e usu�rio.
@Recursos: cenario_dao.lua.
]]--


function selecionar_todos_cenarios (id_projeto)

--@Epis�dio 1:  SELECIONAR TODOS OS CEN�RIOS DO BANCO DE DADOS.
	cenarios = selecionar_todos_cenarios_bd(id_projeto);
--@Epis�dio 2: Os cen�rios obtidos s�o retonados.
	return cenarios;
	
end

--[[
@Titulo:  Selecionar cen�rio.
@Objetivo: Obter todas as informa��es de um determinado cen�rio, identificado pelo id do projeto e pelo t�tulo.
@Contexto: A camada controle chama a fun��o selecionar_cen�rio.
@Atores: browser e usu�rio.
@Recursos: cenario_dao.lua.
]]--

function selecionar_cenario (id_projeto, titulo)

--@Epis�dio 1: SELECIONAR CEN�RIO DO BANCO DE DADOS.
	cenario = selecionar_cenario_bd(id_projeto, titulo);
--@Epis�dio 2: As informa��es obtidas s�o retornadas.
	return cenario;
end


