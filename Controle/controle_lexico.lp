<%

--[[
@Titulo: Controle léxico.
@Objetivo: Selecionar a ação que será executada no módulo léxico.
@Contexto: o usuário deseja realizar uma ação no modulo léxico.
@Atores: browser e usuário.
@Recursos: modelo_lexico.lua.
]]--
--@Episódio 1: Importa o arquivo modelo_lexico.lua.
	dofile("../modelo/modelo_lexico.lua")
%>
<html>
<head>

</head>
<body>
<?lua
	if (cgilua.POST.comando == "cadastrar") then


--@Episódio 2: Se o comando for cadastrar então CHECAR LEXICO.
		ha_lexico = checar_lexico(cgilua.POST.id_projeto, cgilua.POST.nome);

		if (ha_lexico) then

--@Episódio 3: Se  já há algum símbolo do léxico no mesmo projeto com o nome do símbolo que está sendo inserido emite mensagem de erro pro usuário.
			cgilua.put("<br />Já existe símbolo do léxico ou sinônimo com esse nome!");
		end

		cgilua.put("<br />");

--@Episódio 4: Verificar se os sinônimos que estão sendo inseridos coincidem com algum nome do simbolo do léxico ou com o nome de algum outro sinônimo do mesmo projeto.
		--Verifica o tipo de retorno de cgilua.POST.lista_de_sinonimos.
		-- Se o tipo for nil é porque não foi inserido nenhum sinônimo
		-- Se o tipo for string é porque apenas um sinônimo foi inserido
		-- Se o tipo for table é porque mais de um sinônimo foi inserio

		lista_de_sinonimos = {}

		ha_sinonimo = true;

		if (type(cgilua.POST.lista_de_sinonimos) ~= "nil") then

			if (type(cgilua.POST.lista_de_sinonimos) == "string") then
				table.insert(lista_de_sinonimos,cgilua.POST.lista_de_sinonimos)
			else
				lista_de_sinonimos = cgilua.POST.lista_de_sinonimos;
			end
--@Episódio 5: CHECAR SINÔNIMOS
			ha_sinonimo = checar_sinonimos(lista_de_sinonimos, cgilua.POST.id_projeto);

			if (ha_sinonimo) then
--@Episódio 6: Exibe mensagem de erro pro usuário se já tiver algum sinônimo com mesmo nome do símbolo que está sendo inserido.
				cgilua.put("<br />O SINONIMO nao pôde ser inserido pois ja existe um outro sinônimo ou termo do léxico com o mesmo nome");
			end
		else
			ha_sinonimo = false;

		end


--@Episódio 7: Se não há sinônimos nem léxicos com o nome do símbolo que está sendo cadastrado, então CADASTRAR LÉXICO
		if ((not ha_lexico) and (not ha_sinonimo)) then
			lexico_cadastrado = cadastrar_lexico(cgilua.POST.nome, lista_de_sinonimos, cgilua.POST.nocao,
				cgilua.POST.impacto, cgilua.POST.classificacao, cgilua.POST.id_projeto);
			cgilua.redirect("http://localhost:8080/cel/visao/sucesso_lexico.lp", {acao = "cadastrado"})
		end

--@Episódio 8: Se cadastrado com sucesso redireciona para página de sucesso.



	elseif (cgilua.POST.comando == "remover") then


--@Episódio 9: Se comando é remover, então  REMOVER LÉXICO.

		remover_lexico(cgilua.POST.id_projeto, cgilua.POST.nome);

--@Episódio 10: Redireciona para página de sucesso.
		cgilua.redirect("http://localhost:8080/cel/visao/sucesso_lexico.lp", {acao = "removido"});

	elseif (cgilua.POST.comando == "alterar")then

--@Episódio 14: Se comando é alterar, então REMOVER LÉXICO
		remover_lexico(cgilua.POST.id_projeto, cgilua.POST.nome);

--@Episódio 15:  CADASTRAR LÉXICO

		lista_de_sinonimos = {}
		if (type(cgilua.POST.lista_de_sinonimos) ~= "nil") then

			if (type(cgilua.POST.lista_de_sinonimos) == "string") then
				table.insert(lista_de_sinonimos,cgilua.POST.lista_de_sinonimos)
			else
				lista_de_sinonimos = cgilua.POST.lista_de_sinonimos;
			end
		end
		lexico_cadastrado = cadastrar_lexico(cgilua.POST.nome, lista_de_sinonimos, cgilua.POST.nocao,
				cgilua.POST.impacto, cgilua.POST.classificacao, cgilua.POST.id_projeto);
		cgilua.redirect("http://localhost:8080/cel/visao/sucesso_lexico.lp", {acao = "alterado"})
	end
?>

</body>
</html>
