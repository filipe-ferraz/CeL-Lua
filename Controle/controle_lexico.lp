<%

--[[
@Titulo: Controle l�xico.
@Objetivo: Selecionar a a��o que ser� executada no m�dulo l�xico.
@Contexto: o usu�rio deseja realizar uma a��o no modulo l�xico.
@Atores: browser e usu�rio.
@Recursos: modelo_lexico.lua.
]]--
--@Epis�dio 1: Importa o arquivo modelo_lexico.lua.
	dofile("../modelo/modelo_lexico.lua")
%>
<html>
<head>

</head>
<body>
<?lua
	if (cgilua.POST.comando == "cadastrar") then


--@Epis�dio 2: Se o comando for cadastrar ent�o CHECAR LEXICO.
		ha_lexico = checar_lexico(cgilua.POST.id_projeto, cgilua.POST.nome);

		if (ha_lexico) then

--@Epis�dio 3: Se  j� h� algum s�mbolo do l�xico no mesmo projeto com o nome do s�mbolo que est� sendo inserido emite mensagem de erro pro usu�rio.
			cgilua.put("<br />J� existe s�mbolo do l�xico ou sin�nimo com esse nome!");
		end

		cgilua.put("<br />");

--@Epis�dio 4: Verificar se os sin�nimos que est�o sendo inseridos coincidem com algum nome do simbolo do l�xico ou com o nome de algum outro sin�nimo do mesmo projeto.
		--Verifica o tipo de retorno de cgilua.POST.lista_de_sinonimos.
		-- Se o tipo for nil � porque n�o foi inserido nenhum sin�nimo
		-- Se o tipo for string � porque apenas um sin�nimo foi inserido
		-- Se o tipo for table � porque mais de um sin�nimo foi inserio

		lista_de_sinonimos = {}

		ha_sinonimo = true;

		if (type(cgilua.POST.lista_de_sinonimos) ~= "nil") then

			if (type(cgilua.POST.lista_de_sinonimos) == "string") then
				table.insert(lista_de_sinonimos,cgilua.POST.lista_de_sinonimos)
			else
				lista_de_sinonimos = cgilua.POST.lista_de_sinonimos;
			end
--@Epis�dio 5: CHECAR SIN�NIMOS
			ha_sinonimo = checar_sinonimos(lista_de_sinonimos, cgilua.POST.id_projeto);

			if (ha_sinonimo) then
--@Epis�dio 6: Exibe mensagem de erro pro usu�rio se j� tiver algum sin�nimo com mesmo nome do s�mbolo que est� sendo inserido.
				cgilua.put("<br />O SINONIMO nao p�de ser inserido pois ja existe um outro sin�nimo ou termo do l�xico com o mesmo nome");
			end
		else
			ha_sinonimo = false;

		end


--@Epis�dio 7: Se n�o h� sin�nimos nem l�xicos com o nome do s�mbolo que est� sendo cadastrado, ent�o CADASTRAR L�XICO
		if ((not ha_lexico) and (not ha_sinonimo)) then
			lexico_cadastrado = cadastrar_lexico(cgilua.POST.nome, lista_de_sinonimos, cgilua.POST.nocao,
				cgilua.POST.impacto, cgilua.POST.classificacao, cgilua.POST.id_projeto);
			cgilua.redirect("http://localhost:8080/cel/visao/sucesso_lexico.lp", {acao = "cadastrado"})
		end

--@Epis�dio 8: Se cadastrado com sucesso redireciona para p�gina de sucesso.



	elseif (cgilua.POST.comando == "remover") then


--@Epis�dio 9: Se comando � remover, ent�o  REMOVER L�XICO.

		remover_lexico(cgilua.POST.id_projeto, cgilua.POST.nome);

--@Epis�dio 10: Redireciona para p�gina de sucesso.
		cgilua.redirect("http://localhost:8080/cel/visao/sucesso_lexico.lp", {acao = "removido"});

	elseif (cgilua.POST.comando == "alterar")then

--@Epis�dio 14: Se comando � alterar, ent�o REMOVER L�XICO
		remover_lexico(cgilua.POST.id_projeto, cgilua.POST.nome);

--@Epis�dio 15:  CADASTRAR L�XICO

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
