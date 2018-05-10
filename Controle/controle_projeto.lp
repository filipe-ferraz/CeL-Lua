<?lua
--[[
@Titulo: Controle projeto.
@Objetivo: Selecionar a ação que será executada no módulo projeto.
@Contexto: o usuário deseja realizar uma ação no modulo projeto.
@Atores: browser e usuário.
@Recursos: modelo_projeto.lua.
]]--

--@Episódio 1: Importa o arquivo modelo_projeto.lua.
	dofile("../modelo/modelo_projeto.lua")

	if (cgilua.POST.comando == "cadastrar") then

--@Episódio 2: CADASTRAR PROJETO.
		cadastrar_projeto(cgilua.POST.nome, cgilua.POST.descricao, cgilua.POST.id_usuario);

--@Episódio 3: Caso o cadastro tenha sido feito, redireciona para a página de sucesso.
		cgilua.redirect("http://localhost:8080/cel/visao/sucesso_projeto.lp",{acao = "cadastrado"});

	end


?>

