<%
	dofile("../controle/projeto_beans.lua");
	cgilua.enablesession();
	sessao = cgilua.session.load("1")
	if (sessao == nil) then
		cgilua.redirect("http://139.82.24.94:8080/cel/visao/index.html");
	end
	id_usuario = sessao.dados_usuario["ID_USUARIO"];	
%>
<html>
<!--
@Titulo: Exibir p�gina principal 
@Objetivo: Exibir p�gina inicial para o usu�rio.
@Contexto: o usu�rio acessa a p�gina principal index.html
@Atores: browser e usu�rio
@Recursos: scripts.js e estilo.css
-->

<head>
	  <link rel="stylesheet" type="text/css" href="css/estilo.css" />
	  <script src="js/ajax.js" type="text/javascript"></script>
	  <title>C&L - Cen�rios e L�xicos em Lua</title>
</head>
<body onLoad="recarregar_pagina();">

<table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%">
	<tr height="170">
		<td class="titulomedio" align=left width="200" background="imagens\menusuperior.jpg"></td>
		<td class="menuprincipal" align=right valign="bottom" background="imagens\menusuperiorpixel.jpg">
			<table cellpadding=5 cellspacing=5>
				<tr>
					<td colspan=7 align=right>
						<span class=menuprojeto>Projeto :</span>
						<select name="menu_projetos" id="menu_projetos" size="1" onChange="mudar_projeto()">
							<option value="0" selected> -- Selecione um projeto -- </option>
<!--
@ Epis�dio 1: Montar menu de projetos
-->
							<%= carregar_projetos(id_usuario) %>
						</select>
						
					</td>
				</tr>
				<tr>
					<td colspan=7> &nbsp; <td>
				</tr>
				<tr class=menusup>
					<td id=novosimbolo></td>
					<td id=novocenario></td>
					<td><a href="novo_projeto.lp" target="conteudo">Novo Projeto</a></td>
					<td><a href="#">Cadastro</a></td>
					<td><a href="#">Fale Conosco</a></td>
					<td><a href="#">Sair</a></td>
					<td><a href="#">Ajuda</a></td>
					<td></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td class="textonormal" width=230>
			<table class="tableestilo" width=100% height=100% border=0 cellpadding=6>
			<div>
				<tr>	
					<td valign=top>
					<br />
						<ul class="menu_lateral_nivel1">
<!--
@ Epis�dio 2: Montar menu lateral
-->
							<li>Cen�rios</li>
								<ul id="cenario" class="menu_lateral_nivel2">
									
								</ul>	
							<br />		
							<li>L�xicos</li>
								<ul id="lexico" class="menu_lateral_nivel2">
									
								</ul>
							
						</ul>
					</td>
				</tr>
			</div>	
			</table>	
		</td>
		
		<td align=right>
			<table class="tableestilo" width=100% height=100% border=0>
				<tr>	
					<td>
						<iframe id="conteudo" name="conteudo" src="inicial_conteudo.lp" scrolling="auto" width="100%" height="100%">
	
						</iframe>
					</td>
				</tr>
			</table>	
		</td>
		
		
	</tr>
</table>
<body>
</html>