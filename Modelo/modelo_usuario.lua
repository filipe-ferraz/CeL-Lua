dofile("../dao/usuario_dao.lua");
require("md5.core");
--[[
@Titulo: Cadastrar usu�rio.
@Objetivo: Cadastrar o usu�rio no sistema
@Contexto: O usu�rio submeteu o formul�rio de cadastro.
@Atores: usu�rio.
@Recursos: md5.core, usuario_dao.lua
]]--

function cadastrar_usuario (nome, sobrenome, email, instituicao, login, senha)

--@Epis�dio 1: Criptografa a senha fornecida no formul�rio do usu�rio.
	senha_criptografada = md5.sum(senha);

--@Epis�dio 2: INSERIR USU�RIO NO BANCO DE DADOS.
	inserir_usuario_bd(nome, sobrenome, email, instituicao, login, senha_criptografada);

--@Epis�dio 3: SELECIONAR USUARIO NO BANCO DE DADOS.
	usuarios = selecionar_usuario_bd (login);

--@Epis�dio 4: Recupera o id do usu�rio que acabou de ser inserido e retorna ele.
	for index, usuario in pairs(usuarios) do
		id_usuario = usuario["ID_USUARIO"];
		return id_usuario;
	end


end

--[[
@Titulo: Checar login usu�rio
@Objetivo: Verificar se o login escolhido pelo novo usu�rio j� est� cadastrado no banco de dados
@Contexto: Usu�rio preenche o formul�rio de cadastro e o submete.
@Atores: usu�rio.
@Recursos:  usuario_dao.lua
]]--

function checar_login_usuario(login)

--@Epis�dio 1: SELECIONAR USUARIO NO BANCO DE DADOS.
	usuarios = selecionar_usuario_bd(login);

--@Epis�dio 2: Se a consulta retornou resultado retorna true, sen�o retorna false.
	if (#usuarios > 0) then
		return true;
	else
		return false;

	end
end

--[[
@Titulo: Checar usu�rio
@Objetivo: Checar se o usu�rio forneceu os dados login e senha corretos.
@Contexto: Usu�rio deseja se logar no sistema
@Atores: usu�rio.
@Recursos: md5.core, usuario_dao.lua
]]--
function checar_usuario (login, senha)

--@Epis�dio 1: SELECIONAR USUARIO NO BANCO DE DADOS.
	usuarios = selecionar_usuario_bd(login);
	local id_usuario;

--@Epis�dio 2: Se a consulta n�o retornou nenhum usu�rio, retorna false.
	if(#usuarios == 0 )then
		return false;
	else
--@Epis�dio 3: Se a consulta retornou um resultado, ent�o o sistema armazena a senha e o id do usu�rio encontrado.
		senha_recuperada = "";
		for index, usuario in pairs(usuarios) do
			senha_recuperada = usuario["SENHA"];
			id_usuario = usuario["ID_USUARIO"];
		end

--@Epis�dio 4: A senha informada no formul�rio de login � criptografada e comparada com a senha recuperada do banco de dados.
		--senha_criptografada = md5.sum(senha);
		senha_criptografada = senha;
--@Epis�dio 5: Se as senhas forem iguais, ent�o retorna o id do usu�rio e true.
		if (senha_criptografada == senha_recuperada) then
			return true, id_usuario;
		else
--@Epis�dio 6: Se as senhas forem diferentes retorna false.
			return false;
		end

	end
end
