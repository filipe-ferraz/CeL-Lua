
<?lua
--[[
@Titulo: Controle usuário.
@Objetivo: Selecionar a ação que será executada no módulo usuário.
@Contexto: o usuário deseja realizar uma ação no modulo usuário.
@Atores: browser e usuário.
@Recursos: modelo_usuario.lua.
]]--

--@Episódio 1: Importa o arquivo modelo_usuario.lua.
	dofile("../modelo/modelo_usuario.lua")
	cgilua.enablesession();
?>
<html>
<head>
</head>
<body>
<?lua
	if (cgilua.POST.comando == "cadastrar") then

--@Episódio 2: Se o comando for cadastrar CHECAR LOGIN	.
		ha_usuario = checar_login_usuario(cgilua.POST.login);


		if(ha_usuario) then
			cgilua.put("Login já existente, por favor escolha outro login!");
		else
--@Episódio 3: Se o login não se encontra no banco de dados então CADASTRAR_USUARIO
			id_usuario = cadastrar_usuario(cgilua.POST.nome, cgilua.POST.sobrenome, cgilua.POST.email, cgilua.POST.instituicao, cgilua.POST.login, cgilua.POST.senha);

--@Episódio 4: Cria uma sessão e salva nela a variável dados, contendo o id do usuário.
			id_session = cgilua.session.new();
			dados = {};
			dados.dados_usuario = {["ID_USUARIO"] = id_usuario}
			cgilua.session.save("1" , dados);

--@Episódio 5: Redireciona para a página principal do sistema
		cgilua.redirect("http://localhost:8080/cel/visao/principal.lp");
		end
	elseif (cgilua.POST.comando == "logar") then

--@Episódio 6: Se o comando for logar então CHECAR_USUARIO.
		usuario_valido, id_usuario = checar_usuario(cgilua.POST.login, cgilua.POST.senha);

--@Episódio 7: Se o login e a senha fornecidos estiverem corretos, o sistema cria uma sessao e salva nela a variável dados, contendo o id do usuário.
		if (usuario_valido) then

			id_session = cgilua.session.new();
			dados = {};
			dados.dados_usuario = {["ID_USUARIO"] = id_usuario}
			cgilua.session.save("1" , dados);
--@Episódio 7: Redireciona para a página principal do sistema.
			cgilua.redirect("http://localhost:8080/cel/visao/principal.lp");

		else
--@Episódio 8: Se o login e a senha fornecidos forem inválidos exibe uma mensagem de erro na tela.
			cgilua.put("Login ou/e senha errado(s), por favor tente novamente!");
		end
	end
?>
</body>
</html>
