function atualizar_menu_projetos(){
	//parent.document.getElementById("menu_projetos").innerHTML = "<% = carregar_projetos(id_usuario) %>";
}

// Atualiza o menu lateral de léxicos e cenários no caso de uma inclusão / exclusão
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

// É chamada quando a página é carregada/recarregada
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
			novo_simbolo.innerHTML = '<a href="novo_lexico.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo Símbolo</a>';
			novo_cenario.innerHTML = '<a href="novo_cenario.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo Cenário</a>';
		}else{
			novo_simbolo.removeChild(novo_simbolo.firstChild);
			novo_cenario.removeChild(novo_cenario.firstChild);
			novo_simbolo.innerHTML = '<a href="novo_lexico.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo Símbolo</a>';
			novo_cenario.innerHTML = '<a href="novo_cenario.lp?id='+id_projeto_selecionado+'&nome='+nome_projeto_selecionado+'" target="conteudo">Novo Cenário</a>';
		}
	}
}

/*
@Titulo: Listar as cidades
@Objetivo: Fornecer uma lista com as cidades do estado passado por parâmetro.
@Contexto: O usuário seleciona uma cidade e a função ajax() é chamada.
@Atores: browser, aplicação. 
@Recursos: retornaXMLCidades.php, o parâmetro valor contendo a sigla do estado selecionado e o parâmetro controle contendo o id do objeto select onde serão exibidas as cidades.
*/

function ajax(id_projeto, eh_iframe) {
/*@Episódio 1: Criar uma requisição http dependendo do browser que o usuário está utilizando. Emite uma mensagem de alerta caso o browser não possua recursos para o uso do ajax.*/
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
				alert("Seu browser não dá suporte a ajax")
				httprequest = null
            }
        }
    }
	
	if(httprequest) {

		/*@Episódio 3: A requisição é aberta e são passados como parâmetros o método usado para abrí-la, a URL e se a conexão será assincrona ou não.*/
		httprequest.open('POST', '../controle/controle_menu.lp?id_projeto='+id_projeto, true);

		/*@Episódio 4: É definido o tipo de conteudo da requisição e logo em seguida a requisição é enviada para a URL selecionada previamente.*/
		httprequest.setRequestHeader("Content-Type" , "application/x-www-form-urlencoded; charset=iso-8859-1");
		
		httprequest.send(null);
		
		httprequest.onreadystatechange = function () {
			if (httprequest.readyState == 4)
			{
				if (httprequest.status == 200)
				{
					/*@Episódio 5: Quando a requisição estiver pronta PROCESSA O XML.*/
					if(httprequest.responseXML) {
						
						processaXML(httprequest.responseXML, id_projeto, eh_iframe);
						
					} else {
						/*@Episódio 6: Emite uma mensagem quando o arquivo retornado não é um arquivo XML.*/
					  alert("--Erro--");
					}
				}
				else
				{
					/*@Episódio 7: Emite uma mensagem quando o servidor retorna algum tipo de erro.*/
					alert ('O servidor retornou um erro.');
				}
			}
		}
	}
}

/*
@Titulo: Processar o xml
@Objetivo: Permite que os itens recebidos por parâmetro através de um arquivo XML seja exibido para o usuário em uma combo box.
@Contexto: O sistema chama a função processXML.
@Atores: browser e sistema
@Recursos: XML e controle
*/

function processaXML(xmlResponse, id_projeto, eh_iframe){

/*@Episódio 1: Armazena as tags <cidade> que aparecem no arquivo XML na variável cidades.*/
	var cenarios = xmlResponse.getElementsByTagName("cenario");
	var lexicos = xmlResponse.getElementsByTagName("lexico");
	if (!eh_iframe){
		var ul_cenario = document.getElementById('cenario');
		var ul_lexico = document.getElementById('lexico');
	}else{
		var ul_cenario = parent.document.getElementById('cenario');
		var ul_lexico = parent.document.getElementById('lexico');
	}
	
/*@Episódio 2: Verifica se há algum cenário. Se houver percorre o arquivo XML.*/

	if(cenarios.length > 0) {
		 for(var i = 0 ; i < cenarios.length ; i++) {
			var item = cenarios[i];
			/*@Episódio 3: Armazena na variável título o título do cenário retirado da tag <titulo> do arquivo XML.*/
			var titulo =  item.getElementsByTagName("titulo")[0].firstChild.nodeValue;
			
			/*@Episódio 4: Cria um novo li dinamicamente.*/
			if (!eh_iframe){
				var novo_li_cenario = document.createElement("li");
			}else{
				var novo_li_cenario = parent.document.createElement("li");
			}
			/*@Episódio 5: Atribui um id ao option criado.*/
			//novo.setAttribute("id", "cidade");
			
			/*@Episódio 6: Atribui um valor e um texto ao option criado.*/
			//novo.value = nome;
			titulo_url = replaceAll(titulo," ","%20");
			novo_li_cenario.innerHTML='<a href=../visao/exibe_cenario.lp?id_projeto='+id_projeto+'&titulo='+titulo_url+' target="conteudo">'+titulo+'</a>';

			/*@Episódio 7: Adiciona o option criado a combo box.*/
			ul_cenario.appendChild(novo_li_cenario);
			
		}
	} else {
		/*@Episódio 8: Emite mensagem de erro caso o XML esteja vazioAdiciona o option criado a combo box.*/
		if (!eh_iframe){
				var novo_li_cenario = document.createElement("li");
			}else{
				var novo_li_cenario = parent.document.createElement("li");
		}
		novo_li_cenario.innerHTML="Não há nenhum cenário neste projeto."
		ul_cenario.appendChild(novo_li_cenario);
		
	}

	if(lexicos.length > 0) {
		 for(var i = 0 ; i < lexicos.length ; i++) {
			var item = lexicos[i];
			/*@Episódio 3: Armazena na variável título o título do cenário retirado da tag <titulo> do arquivo XML.*/
			var nome =  item.getElementsByTagName("nome")[0].firstChild.nodeValue;
			
			/*@Episódio 4: Cria um novo li dinamicamente.*/
			if (!eh_iframe){
				var novo_li_lexico = document.createElement("li");
			}else{
				var novo_li_lexico = parent.document.createElement("li");
			}
			
			/*@Episódio 5: Atribui um id ao option criado.*/
			//novo.setAttribute("id", "cidade");
			
			/*@Episódio 6: Atribui um valor e um texto ao option criado.*/
			//novo.value = nome;
			nome_url = replaceAll(nome," ","%20");
			novo_li_lexico.innerHTML= '<a href=../visao/exibe_lexico.lp?id_projeto='+id_projeto+'&nome='+nome_url+' target="conteudo">'+nome+'</a>';;
			
			/*@Episódio 7: Adiciona o option criado a combo box.*/
			ul_lexico.appendChild(novo_li_lexico);
			
		}
	} else {
		/*@Episódio 8: Emite mensagem de erro caso o XML esteja vazioAdiciona o option criado a combo box.*/
		if (!eh_iframe){
				var novo_li_lexico = document.createElement("li");
			}else{
				var novo_li_lexico = parent.document.createElement("li");
		}
		novo_li_lexico.innerHTML="Não há nenhum símbolo neste projeto."
		ul_lexico.appendChild(novo_li_lexico);
		
	}	
  
}
// substitui todas as ocorrencias de token nas strings pelo símbolo em newtoken
function replaceAll(string, token, newtoken) {
	while (string.indexOf(token) != -1) {
 		string = string.replace(token, newtoken);
	}
	return string;
}