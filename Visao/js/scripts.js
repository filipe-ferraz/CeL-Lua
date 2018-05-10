// Remove os espaços em branco a esquerda da palavra
String.prototype.ltrim = function() {
    return this.replace(/^\s+/,"");
}
// Validar formulário de cadastro de léxicos

function verificar_formulario_lexico() {
	
	formulario = document.frmLexico;

	//Verifica se o campo nome do léxico está vazio
	if (formulario.nome.value.ltrim() == ""){
	   alert("O campo " + formulario.nome.name + " deve ser preenchido!");
	   formulario.nome.focus();
	   return false;
	}
	
	//Verifica se o campo noção do léxico está vazio
	if (formulario.nocao.value.ltrim() == ""){
	   alert("O campo " + formulario.nocao.name + " deve ser preenchido!");
	   formulario.nocao.focus();
	   return false;
	}
	
	//Verifica se o campo impacto do léxico está vazio
	if (formulario.impacto.value.ltrim() == ""){
	   alert("O campo " + formulario.impacto.name + " deve ser preenchido!");
	   formulario.impacto.focus();
	   return false;
	}
			
}

//Validar formulário de cadastro de cenários

function verificar_formulario_cenario()
{
	formulario = document.frmCadastroCenario;
	
	//Verifica se o campo titulo do cenário está vazio.
	if (formulario.titulo.value.ltrim() == ""){
	   alert("O campo " + formulario.titulo.name + " deve ser preenchido!");
	   formulario.titulo.focus();
	   return false;
	}
	
	//Verifica se o campo objetivo do cenário esta preenchido
	if (formulario.objetivo.value.ltrim() == ""){
	   alert("O campo " + formulario.objetivo.name + " deve ser preenchido!");
	   formulario.objetivo.focus();
	   return false;
	}
	
	//Verifica se o campo contexto do cenário está preenchido
	if (formulario.contexto.value.ltrim() == ""){
	   alert("O campo " + formulario.contexto.name + " deve ser preenchido!");
	   formulario.contexto.focus();
	   return false;
	}
	
	//Verifica se o campo atores do cenário está vazio
	if (formulario.atores.value.ltrim() == ""){
	   alert("O campo " + formulario.atores.name + " deve ser preenchido!");
	   formulario.atores.focus();
	   return false;
	}
	
	//Verifica se o campo recursos do cenário está vazio
	if (formulario.recursos.value.ltrim() == ""){
	   alert("O campo " + formulario.recursos.name + " deve ser preenchido!");
	   formulario.recursos.focus();
	   return false;
	}
	
	//Verifica se o campo episodios do cenário está vazio
	if (formulario.episodios.value.ltrim() == ""){
	   alert("O campo " + formulario.episodios.name + " deve ser preenchido!");
	   formulario.episodios.focus();
	   return false;
	}
	return true;
}

// Validar formulário de cadastro de projetos

function verificar_formulario_projeto()
{
	formulario = document.form_projeto;
	
	//Verifica se o campo nome do projeto está vazio
	if (formulario.nome.value.ltrim() == ""){
	   alert("O campo " + formulario.nome.name + " deve ser preenchido!");
	   formulario.nome.focus();
	   return false;
	}
	
	//Verifica se o campo sobrenome está vazio
	if (formulario.descricao.value.ltrim() == ""){
	   alert("O campo " + formulario.descricao.name + " deve ser preenchido!");
	   formulario.descricao.focus();
	   return false;
	}

	return true;
}


//Validar formulário de cadastro de usuário
function verificar_formulario_usuario()
{
	formulario = document.frmCadastro;
	
	//Verifica se o campo nome está vazio
	if (formulario.nome.value.ltrim() == ""){
	   alert("O campo " + formulario.nome.name + " deve ser preenchido!");
	   formulario.nome.focus();
	   return false;
	}
	
	//Verifica se o campo sobrenome está vazio
	if (formulario.sobrenome.value.ltrim() == ""){
	   alert("O campo " + formulario.sobrenome.name + " deve ser preenchido!");
	   formulario.sobrenome.focus();
	   return false;
	}

	//Verifica se o campo email está vazio 
	if (formulario.email.value.ltrim() == ""){
	   alert("O campo " + formulario.email.name + " deve ser preenchido!");
	   formulario.email.focus();
	   return false;
	}

	// Verifica se o campo instituição
	if (formulario.instituicao.value.ltrim() == ""){
	   alert("O campo " + formulario.instituicao.name + " deve ser preenchido!");
	   formulario.instituicao.focus();
	   return false;
	}

	// Verifica se o campo login está vazio
	if (formulario.login.value.ltrim() == ""){
	   alert("O campo " + formulario.login.name + " deve ser preenchido!");
	   formulario.login.focus();
	   return false;
	}

	//Verifica se o campo senha está vazio
	if (formulario.senha.value.ltrim() == ""){
	   alert("O campo " + formulario.senha.name + " deve ser preenchido!");
	   formulario.senha.focus();
	   return false;
	}

	// Verifica se o conteudo do campo senha é igual ao do campo verificar senha
	if (formulario.senha.value != formulario.confirmarsenha.value){
	   alert("O campo " + formulario.confirmarsenha.name + " deve conter a mesma senha digitada no campo senha!");
	   formulario.confirmarsenha.focus();
	   return false;
	}
	return true;
}



//Adicionar sinônimo na lista de sinônimos
function adicionar_sinonimo()
{
	lista_de_sinonimos = document.forms[0].elements['lista_de_sinonimos'];

	if(document.forms[0].sinonimo.value == "")
	    return;

	sinonimo = document.forms[0].sinonimo.value;
	padrao = /[\\\/\?"<>:|]/;
	nOK = padrao.exec(sinonimo);
	if (nOK)
	{
	    window.alert ("O sinônimo do léxico não pode conter nenhum dos seguintes caracteres:   / \\ : ? \" < > |");
	    document.forms[0].sinonimo.focus();
	    return;
	}

	//verifica se ja existe algum sinônimo na lista com o mesmo nome do que está sendo inserido
	
	for (i=0; i < lista_de_sinonimos.length; i++)
    {
		if(sinonimo == lista_de_sinonimos.options[i].text)
		{
			alert("Voce já adicionou um sinônimo com o nome "+sinonimo+"!");
			return;
		}
    }
	
	lista_de_sinonimos.options[lista_de_sinonimos.length] = new Option(document.forms[0].sinonimo.value, document.forms[0].sinonimo.value);

	document.forms[0].sinonimo.value = "";

	document.forms[0].sinonimo.focus();

}


// Remover sinônimo da lista de sinonimos
function remover_sinonimo()
{
	lista_de_sinonimos = document.forms[0].elements['lista_de_sinonimos'];

	if(lista_de_sinonimos.selectedIndex == -1)
		return;
	else
		lista_de_sinonimos.options[lista_de_sinonimos.selectedIndex] = null;
	
	remover_sinonimo();

}

// submete o formulario de lexico
function submeter_formulario_lexico(acao){
		
	if (acao == "remover"){
		document.dadosLexico.action = "../controle/controle_lexico.lp";
		document.getElementById("comando").value = "remover";
	} else if (acao == "alterar"){
		document.dadosLexico.action = "alterar_lexico.lp";
	}
	document.dadosLexico.submit();
	
}

// submete o formulário de cenários
function submeter_formulario_cenario(acao){
		
	if (acao == "remover"){
		document.dadosCenario.action = "../controle/controle_cenario.lp";
		document.getElementById("comando").value = "remover";
	} else if (acao == "alterar"){
		document.dadosCenario.action = "alterar_cenario.lp";
	}
	document.dadosCenario.submit();
	
}




 