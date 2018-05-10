function atualizar_menu_projetos(){
	//parent.document.getElementById("menu_projetos").innerHTML = "<% = carregar_projetos(id_usuario) %>";
}

// Atualiza o menu lateral de l�xicos e cen�rios no caso de uma inclus�o / exclus�o
function atualizar_menu_lateral(){
	
	var	menu_cenario = parent.document.getElementById("cenario");
	var menu_lexico = parent.document.getElementById("lexico");
	
	while (menu_cenario.firstChild) {
		menu_cenario.removeChild(menu_cenario.firstChild);
	}
	
	while (menu_lexico.firstChild) {
		menu_lexico.removeChild(menu_lexico.firstChild);
	}
	
	var menu = parent.document.getElementById("menu_projetos")
	
	projeto_selecionado= menu.options[menu.selectedIndex];
	
	ajax(projeto_selecionado.value, true);
}

// � chamada quando a p�gina � carregada/recarregada
function recarregar_pagina(){
	var menu = document.getElementById("menu_projetos");
	menu.options[0].selected = true;
	document.getElementById('conteudo').src = 'inicial_conteudo.lp';
}

function mudar_projeto(){
	
	var menu_cenario = document.getElementById("cenario");
	
	var menu_lexico = document.getElementById("lexico");
		
	while (menu_cenario.firstChild) {
		menu_cenario.removeChild(menu_cenario.firstChild);
	}
	
	while (menu_lexico.firstChild) {
		menu_lexico.removeChild(menu_lexico.firstChild);
	}
	
	var menu = document.getElementById("menu_projetos")
	
	projeto_selecionado= menu.options[menu.selectedIndex];
	
	if (projeto_selecionado.value > 0){
		document.getElementById('conteudo').src = 'inicial_projeto.lp';
	}else{
		document.getElementById('conteudo').src = 'inicial_conteudo.lp';
	}
	
	montar_menusuperior(projeto_selecionado.value, projeto_selecionado.text);
	ajax(projeto_selecionado.value);
}

function montar_menusuperior(id_projeto_selecionado, nome_projeto_selecionado){
	var novo_simbolo = document.getElementById("novosimbolo");
	var novo_cenario = document.getElementById("novocenario");
	
	if (id_projeto_selecionado < 1){
		if(novo_simbolo.firstChild){
			novo_simbolo.removeChild(novo_simbolo.firstChild);
			novo_cenario.removeChild(novo_cenario.firstChild);
		}
	}else{
		if(!novo_simbolo.firstChild){
			novo_simbolo.innerHTML = '<a href="novo_lexico.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo S�mbolo</a>';
			novo_cenario.innerHTML = '<a href="novo_cenario.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo Cen�rio</a>';
		}else{
			novo_simbolo.removeChild(novo_simbolo.firstChild);
			novo_cenario.removeChild(novo_cenario.firstChild);
			novo_simbolo.innerHTML = '<a href="novo_lexico.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo S�mbolo</a>';
			novo_cenario.innerHTML = '<a href="novo_cenario.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo Cen�rio</a>';
		}
	}
}

/*
@Titulo: Listar as cidades
@Objetivo: Fornecer uma lista com as cidades do estado passado por par�metro.
@Contexto: O usu�rio seleciona uma cidade e a fun��o ajax() � chamada.
@Atores: browser, aplica��o. 
@Recursos: retornaXMLCidades.php, o par�metro valor contendo a sigla do estado selecionado e o par�metro controle contendo o id do objeto select onde ser�o exibidas as cidades.
*/

function ajax(id_projeto, eh_iframe) {
/*@Epis�dio 1: Criar uma requisi��o http dependendo do browser que o usu�rio est� utilizando. Emite uma mensagem de alerta caso o browser n�o possua recursos para o uso do ajax.*/
	try {   
		httprequest = new XMLHttpRequest()
    } 
	catch (e) {
   		try {
      		httprequest = new ActiveXObject("Microsoft.XMLHTTP")
      	}
      	catch (ex) {
      		try {
      		   httprequest = new ActiveXObject("Msxml2.XMLHTTP")
      		}
      		catch (exc) {
				alert("Seu browser n�o d� suporte a ajax")
				httprequest = null
            }
        }
    }
	
	if(httprequest) {

		/*@Epis�dio 3: A requisi��o � aberta e s�o passados como par�metros o m�todo usado para abr�-la, a URL e se a conex�o ser� assincrona ou n�o.*/
		httprequest.open('POST', '../controle/controle_menu.lp?id_projeto='+id_projeto, true);

		/*@Epis�dio 4: � definido o tipo de conteudo da requisi��o e logo em seguida a requisi��o � enviada para a URL selecionada previamente.*/
		httprequest.setRequestHeader("Content-Type" , "application/x-www-form-urlencoded; charset=iso-8859-1");
		
		httprequest.send(null);
		
		httprequest.onreadystatechange = function () {
			if (httprequest.readyState == 4)
			{
				if (httprequest.status == 200)
				{
					/*@Epis�dio 5: Quando a requisi��o estiver pronta PROCESSA O XML.*/
					if(httprequest.responseXML) {
						
						processaXML(httprequest.responseXML, id_projeto, eh_iframe);
						
					} else {
						/*@Epis�dio 6: Emite uma mensagem quando o arquivo retornado n�o � um arquivo XML.*/
					  alert("--Erro--");
					}
				}
				else
				{
					/*@Epis�dio 7: Emite uma mensagem quando o servidor retorna algum tipo de erro.*/
					alert ('O servidor retornou um erro.');
				}
			}
		}
	}
}

/*
@Titulo: Processar o xml
@Objetivo: Permite que os itens recebidos por par�metro atrav�s de um arquivo XML seja exibido para o usu�rio em uma combo box.
@Contexto: O sistema chama a fun��o processXML.
@Atores: browser e sistema
@Recursos: XML e controle
*/

function processaXML(xmlResponse, id_projeto, eh_iframe){

/*@Epis�dio 1: Armazena as tags <cidade> que aparecem no arquivo XML na vari�vel cidades.*/
	var cenarios = xmlResponse.getElementsByTagName("cenario");
	var lexicos = xmlResponse.getElementsByTagName("lexico");
	if (!eh_iframe){
		var ul_cenario = document.getElementById('cenario');
		var ul_lexico = document.getElementById('lexico');
	}else{
		var ul_cenario = parent.document.getElementById('cenario');
		var ul_lexico = parent.document.getElementById('lexico');
	}
	
/*@Epis�dio 2: Verifica se h� algum cen�rio. Se houver percorre o arquivo XML.*/

	if(cenarios.length > 0) {
		 for(var i = 0 ; i < cenarios.length ; i++) {
			var item = cenarios[i];
			/*@Epis�dio 3: Armazena na vari�vel t�tulo o t�tulo do cen�rio retirado da tag <titulo> do arquivo XML.*/
			var titulo =  item.getElementsByTagName("titulo")[0].firstChild.nodeValue;
			
			/*@Epis�dio 4: Cria um novo li dinamicamente.*/
			if (!eh_iframe){
				var novo_li_cenario = document.createElement("li");
			}else{
				var novo_li_cenario = parent.document.createElement("li");
			}
			/*@Epis�dio 5: Atribui um id ao option criado.*/
			//novo.setAttribute("id", "cidade");
			
			/*@Epis�dio 6: Atribui um valor e um texto ao option criado.*/
			//novo.value = nome;
			titulo_url = replaceAll(titulo," ","%20");
			novo_li_cenario.innerHTML='<a href=../visao/exibe_cenario.lp?id_projeto='+id_projeto+'&titulo='+titulo_url+' target="conteudo">'+titulo+'</a>';

			/*@Epis�dio 7: Adiciona o option criado a combo box.*/
			ul_cenario.appendChild(novo_li_cenario);
			
		}
	} else {
		/*@Epis�dio 8: Emite mensagem de erro caso o XML esteja vazioAdiciona o option criado a combo box.*/
		if (!eh_iframe){
				var novo_li_cenario = document.createElement("li");
			}else{
				var novo_li_cenario = parent.document.createElement("li");
		}
		novo_li_cenario.innerHTML="N�o h� nenhum cen�rio neste projeto."
		ul_cenario.appendChild(novo_li_cenario);
		
	}

	if(lexicos.length > 0) {
		 for(var i = 0 ; i < lexicos.length ; i++) {
			var item = lexicos[i];
			/*@Epis�dio 3: Armazena na vari�vel t�tulo o t�tulo do cen�rio retirado da tag <titulo> do arquivo XML.*/
			var nome =  item.getElementsByTagName("nome")[0].firstChild.nodeValue;
			
			/*@Epis�dio 4: Cria um novo li dinamicamente.*/
			if (!eh_iframe){
				var novo_li_lexico = document.createElement("li");
			}else{
				var novo_li_lexico = parent.document.createElement("li");
			}
			
			/*@Epis�dio 5: Atribui um id ao option criado.*/
			//novo.setAttribute("id", "cidade");
			
			/*@Epis�dio 6: Atribui um valor e um texto ao option criado.*/
			//novo.value = nome;
			nome_url = replaceAll(nome," ","%20");
			novo_li_lexico.innerHTML= '<a href=../visao/exibe_lexico.lp?id_projeto='+id_projeto+'&nome='+nome_url+' target="conteudo">'+nome+'</a>';;
			
			/*@Epis�dio 7: Adiciona o option criado a combo box.*/
			ul_lexico.appendChild(novo_li_lexico);
			
		}
	} else {
		/*@Epis�dio 8: Emite mensagem de erro caso o XML esteja vazioAdiciona o option criado a combo box.*/
		if (!eh_iframe){
				var novo_li_lexico = document.createElement("li");
			}else{
				var novo_li_lexico = parent.document.createElement("li");
		}
		novo_li_lexico.innerHTML="N�o h� nenhum s�mbolo neste projeto."
		ul_lexico.appendChild(novo_li_lexico);
		
	}	
  
}
// substitui todas as ocorrencias de token nas strings pelo s�mbolo em newtoken
function replaceAll(string, token, newtoken) {
	while (string.indexOf(token) != -1) {
 		string = string.replace(token, newtoken);
	}
	return string;
}