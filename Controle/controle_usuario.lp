
<?lua
--[[
@Titulo: Controle usu�rio.
@Objetivo: Selecionar a a��o que ser� executada no m�dulo usu�rio.
@Contexto: o usu�rio deseja realizar uma a��o no modulo usu�rio.
@Atores: browser e usu�rio.
@Recursos: modelo_usuario.lua.
]]--

--@Epis�dio 1: Importa o arquivo modelo_usuario.lua.
	dofile("../modelo/modelo_usuario.lua")
	cgilua.enablesession();
?>
<html>
<head>
</head>
<body>
<?lua
	if (cgilua.POST.comando == "cadastrar") then

--@Epis�dio 2: Se o comando for cadastrar CHECAR LOGIN	.
		ha_usuario = checar_login_usuario(cgilua.POST.login);


		if(ha_usuario) then
			cgilua.put("Login j� existente, por favor escolha outro login!");
		else
--@Epis�dio 3: Se o login n�o se encontra no banco de dados ent�o CADASTRAR_USUARIO
			id_usuario = cadastrar_usuario(cgilua.POST.nome, cgilua.POST.sobrenome, cgilua.POST.email, cgilua.POST.instituicao, cgilua.POST.login, cgilua.POST.senha);

--@Epis�dio 4: Cria uma sess�o e salva nela a vari�vel dados, contendo o id do usu�rio.
			id_session = cgilua.session.new();
			dados = {};
			dados.dados_usuario = {["ID_USUARIO"] = id_usuario}
			cgilua.session.save("1" , dados);

--@Epis�dio 5: Redireciona para a p�gina principal do sistema
		cgilua.redirect("http://localhost:8080/cel/visao/principal.lp");
		end
	elseif (cgilua.POST.comando == "logar") then

--@Epis�dio 6: Se o comando for logar ent�o CHECAR_USUARIO.
		usuario_valido, id_usuario = checar_usuario(cgilua.POST.login, cgilua.POST.senha);

--@Epis�dio 7: Se o login e a senha fornecidos estiverem corretos, o sistema cria uma sessao e salva nela a vari�vel dados, contendo o id do usu�rio.
		if (usuario_valido) then

			id_session = cgilua.session.new();
			dados = {};
			dados.dados_usuario = {["ID_USUARIO"] = id_usuario}
			cgilua.session.save("1" , dados);
--@Epis�dio 7: Redireciona para a p�gina principal do sistema.
			cgilua.redirect("http://localhost:8080/cel/visao/principal.lp");

		else
--@Epis�dio 8: Se o login e a senha fornecidos forem inv�lidos exibe uma mensagem de erro na tela.
			cgilua.put("Login ou/e senha errado(s), por favor tente novamente!");
		end
	end
?>
</body>
</html>
