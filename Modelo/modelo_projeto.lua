dofile("../dao/projeto_dao.lua");
dofile("../dao/cenario_dao.lua");
dofile("../dao/lexico_dao.lua");
require("md5.core");


--[[
@Titulo:  Selecionar projeto.
@Objetivo: Obter as informações sobre um projeto específico
@Contexto: A camada controle chama a função selecionar_projeto.
@Atores: browser e usuário.
@Recursos: projeto_dao.lua.
]]--

function selecionar_projeto (id_projeto)

--@Episódio 1: SELECIONAR PROJETO DO BANCO DE DADOS.
	projeto = selecionar_projeto_bd(id_projeto);

--@Episódio 2: Retorna informações do projeto
	return projeto;

end


--[[
@Titulo:  Selecionar projetos.
@Objetivo: Selecionar todos os projetos de um determinado usuário.
@Contexto: A camada controle chama a função selecionar_projetos.
@Atores: browser e usuário.
@Recursos: projeto_dao.lua.
]]--


function selecionar_projetos (id_usuario)

--@Episódio 1: SELECIONAR PROJETOS DO BANCO DE DADOS.
	projetos = selecionar_projetos_bd (id_usuario);

--@Episódio 2: Retorna a lista de projetos.
	return projetos;

end

--[[
@Titulo: Cadastrar projeto.
@Objetivo: Cadastrar o projeto no sistema
@Contexto: O usuário submete o formulário de cadastro de projeto.
@Atores: usuário.
@Recursos:  projeto_dao.lua
]]--

function cadastrar_projeto(nome, descricao, id_usuario)

--@Episódio 1: Obtém do sistema a data em que esta sendo feito o cadastro.
	data = os.date("%Y-%m-%d %H:%M:%S"); 
	
--@Episódio 2: INSERIR PROJETO NO BANCO DE DADOS
	inserir_projeto_bd(nome, descricao, data, id_usuario);

end 

--[[
@Titulo: Contar palavras.
@Objetivo: Recebe um texto como parâmetro e retorna o número de palavras que compõe o texto.
@Contexto: a função conta_palavras é chamada
@Atores: usuário.
@Recursos:  
]]--

function conta_palavras(texto)

--@Episódio 1: Inicializa o contador com o valor 0.
	contador_palavras = 0;

--@Episódio 2: Para cada caracter alfanumerico segui de um ou mais caracteres alfanúmericos (%w+) o contador de palavras é incrementado de 1.	
	for palavra in string.gmatch(texto, "%w+") do
		contador_palavras = contador_palavras+1;
	end
	
--@Episódio 3: Retorna o contador de palavras
	return contador_palavras;
end

--[[
@Titulo: Particionar tabela.
@Objetivo: Organizar a tabela, escolher o pivô e particiona-la (partition do quicksort).
@Contexto: a função particao é chamada
@Atores: usuário.
@Recursos:  
]]--

function particao( elementos, inicio, fim, tipo )
	
--@Episódio 1: Inicializa as variáveis i, j e dir.
    i = inicio;
    j = fim;
    dir = 1;
    
    while( i < j ) do
	
--@Episódio 2: Enquanto i < j percorre a tabela elementos.
    	if(tipo == "cenario") then

--@Episódio 3: Se tipo igual a cenário, então se CONTA PALAVRAS do elemento na posição i for menor que CONTA PALAVRAS do elemento na posição j, então eles são trocados.
    		if( conta_palavras( elementos[i]["TITULO"] ) < conta_palavras( elementos[j]["TITULO"] ) ) then
	        
				temporario = elementos[i];
	            elementos[i] = elementos[j];
	            elementos[j] = temporario;
	            dir = dir -1;
	        end	
    	
		else
--@Episódio 4: Se tipo igual a lexico, então se CONTA PALAVRAS do elemento na posição i for menor que CONTA PALAVRAS do elemento na posição j, então eles são trocados.	    
			if( conta_palavras( elementos[i]["NOME"] ) < conta_palavras( elementos[j]["NOME"] ) ) then
	        
				temporario = elementos[i];
	            elementos[i] = elementos[j];
	            elementos[j] = temporario;
	            dir = dir - 1;
			end	
				
	  	end
--@Episódio 5: Se não houve nenhuma troca, isto é, se dir diferente igual a 1, então a variável j é decrementada de 1, senão a variável i é incrementada de 1.
        if( dir == 1 ) then
            j = j - 1;
        else
            i = i + 1;
		end	
    end
--@Episódio 6: Retorna o valor da variável i.
    return i;
	
end

--[[
@Titulo: Ordenar a tabela.
@Objetivo: Ordena a tabela colocando as palavras compostas de mais palavras na frente.
@Contexto: a função ordena_tabela é chamada
@Atores: usuário.
@Recursos:  
]]--


function ordena_tabela(tabela, inicio, fim, tipo )

    
	if( inicio < fim ) then
--@Episódio 1:  Se inicio < fim, então PARTICIONAR TABELA
        pivo = particao(tabela, inicio, fim, tipo );
		
--@Episódio 2: Chama recursivamente a funcao ordena_tabela para a primeira  metade da tabela.
	    ordena_tabela( tabela, inicio, pivo-1, tipo );
		
--@Episódio 3: Chama recursivamente a funcao ordena_tabela para a segunda  metade da tabela.
        ordena_tabela( tabela, pivo+1, fim, tipo );
    
	end
	
--@Episódio 4: retorna a tabela ordenada
	return tabela;
	
end	

--[[
@Titulo: Colocar links
@Objetivo: Procurar o texto passado por parâmetro qualquer referência a elementos do projeto passado por parâmetro. Caso encontre alguma ocorrência, substitui o termo encontrado por um link para sua definição.
@Contexto: a função coloca_links é chamada
@Atores: usuário.
@Recursos:  
]]--

	
function coloca_links (id_projeto, texto, tipo)


--@Episódio 1: SELECIONAR TODOS OS LEXICOS DO BANCO DE DADOS
	lexicos = selecionar_todos_lexicos_bd(id_projeto);
	
--@Episódio 2: SELECIONAR TODOS OS SINÔNIMOS DO BANCO DE DADOS
	sinonimos = selecionar_sinonimos_projeto_bd(id_projeto);

--@Episódio 3: SELECIONAR TODOS OS CENÁRIOs DO BANCO DE DADOS
	cenarios = selecionar_todos_cenarios_bd(id_projeto);
	
--@Episódio 4: Monta uma tabela única com léxicos e sinônimos	
	for index, sinonimo in pairs(sinonimos) do
		table.insert(lexicos, sinonimo);
	end 
	lexicos_e_sinonimos = lexicos;
	
--@Episódio 5: ORDENAR TABELA sinonimos.
	sinonimos = ordena_tabela(sinonimos, 1, table.maxn(sinonimos) ,"lexico" )
	
--@Episódio 6: ORDENAR TABELA cenários
	cenarios =  ordena_tabela(cenarios, 1, table.maxn(cenarios) ,"cenario" )
	
--@Episódio 7: ORDENAR TABELA lexicos_e_sinonimos.	
	lexicos_e_sinonimos = ordena_tabela(lexicos_e_sinonimos, 1, table.maxn(lexicos_e_sinonimos),"lexico" )
	
--@Episódio 8: O tamanho da tabela lexicos_e_sinonimos é armazenado na variável tam_lexicos_e_sinonimos
	tam_lexicos_e_sinonimos = #lexicos_e_sinonimos;
	
--@Episódio 9: O tamanho da tabela cenarios é armazenado na variável tam_cenarios
	tam_cenarios = #cenarios;
	
--@Episódio 10: O tamanho da tabela tam_lexicos_e_sinonimos somado com o tamanho da tabela cenarios é armazenado na variável tam_total
	tam_total = tam_lexicos_e_sinonimos + tam_cenarios ;
	
--@Episódio 11: Cria tabelas que armazenarão os links criados para léxicos e para cenários.	
	tabela_links_lexico = {};
	tabela_links_cenario = {};
		

	if ((tipo == "lexico") or (tam_cenarios == 0)) then
--@Episódio 12: Se não há cenários no projeto então percorreremos apenas a lista de lexicos e sinônimos.
		for index, lexico in pairs(lexicos_e_sinonimos) do

--@Episódio 13: A variável nome_lexico recebe o nome do léxico ou sinônimo atual.
			nome_lexico = lexico["NOME"];
			
--@Episódio 14: Uma expressão regular é montada com a variável nome_lexico e armazenada na variável expressao_regular			
			expressao_regular = "("..nome_lexico..")";

			if (string.find(texto, expressao_regular) ~= nil) then
--@Episódio 15: Se alguma ocorrência de expressão regular for encontrada no texto, então está expressão é subistituida por um código (wzzxkkxy) seguido da posição do léxico na tabela lexicos e sinonimos
				texto = string.gsub(texto, expressao_regular, "wzzxk"..index.."kxy");

--@Episódio 16: verifica se a expressao encontrada é realmente um léxico ou é um sinônimo de um léxico 
				if (lexico["LEXICO"] ~= nil) then
				
--@Episódio 16: Se a expressão encontrada for um sinônimo então o nome_lexico_link deve ser o nome do léxico a que pertence o sinônimo
					nome_lexico_link = lexico["LEXICO"]
				else
				
--@Episódio 16: Se a expressão encontrada for um léxico então o nome_lexico_link deve ser o nome do léxico.
					nome_lexico_link = nome_lexico;
				end	
--@Episódio 18:  Monta o link da expressão encontrada
				link = "<a title=\"Léxico\" href=\"../visao/exibe_lexico.lp?id_projeto="..id_projeto.."&nome="..nome_lexico_link.."\">"..nome_lexico.."</a>";

--@Episódio 19: insere o link na tabela de links lexico na posição em que o elemento encontrado ocupa na tabela lexicos_e_sinonimos. 
				table.insert(tabela_links_lexico, index, link);
			end --if
				
	    end --for
	
	else	
	
		if (tam_lexicos_e_sinonimos == 0 and tam_cenarios > 0) then
		
--@Episódio 20: Se não há léxicos no projeto então percorreremos apenas a lista de cenários
			for index, cenario in pairs(cenarios) do
			
--@Episódio 21: A variável nome_cenario recebe o título do cenário atual	
		        nome_cenario = cenario["TITULO"];
				
--@Episódio 22: Uma expressão regular é montada com a variável nome_cenario e armazenada na variável expressao_regular
				expressao_regular = "("..nome_cenario..")";
							
				if (string.find(texto, expressao_regular) ~= nil) then
				
--Episódio 23: Se alguma ocorrência de expressão regular for encontrada no texto, então um link é montado com o nome do cenário
					link = "<a title=\"Cenário\" href=\"../visao/exibe_cenario.lp?id_projeto="..id_projeto.."&titulo="..titulo_cenario.."&comando=exibir\">"..titulo_cenario.."</a>";
					
--Episódio 23: O link montado é inserido na tabela links cenário na posição que o cenário encontrado ocupa na tabela cenários
					table.insert(tabela_links_cenario, index, link);
					
--@Episódio 24:  A expressão regular é subistituida por um código (wzzxkkxyyc) seguido da posição do cenario na tabela cenarios
					texto = string.gsub(texto, expressao_regular, "wzczxk"..i.."kxyyc");
				end --if
				
		    end	-- for
		
		elseif (tam_total > 0) then
			
			--Se o vetor de cenários não estiver vazio ele irá procurar por léxicos e cenários
			i = 1;
			j = 1;
					
			contador = 1;
--@Episódio 25:  Se o projeto possuir cenários e léxicos, então as listas de léxicos e cenários serão percorridas.
			while (contador <= tam_total) do
						
				if ( ( i <= tam_lexicos_e_sinonimos ) and (j <= tam_cenarios) ) then
					
--@Episódio 26:  Se a lista de cenários não chegou ao fim e a lista de léxicos também não chegou ao fim então CONTAR PALAVRAS do titulo do cenário e CONTAR PALAVRAS do nome do léxico
					if ( conta_palavras(cenarios[j]["TITULO"]) <= conta_palavras(lexicos_e_sinonimos[i]["NOME"]) ) then
					    
--@Episódio 27:  Se o título do cenário atual possui um número menor ou igual de palavras que o nome do léxico, então procuraremos a ocorrência deste léxico no texto
						nome_lexico = lexicos_e_sinonimos[i]["NOME"];
					
						expressao_regular = "("..nome_lexico..")";
						
						if( string.gfind(texto, expressao_regular) ~= nil ) then
						
							texto = string.gsub(texto, expressao_regular, "wzzxk"..i.."kxy");
							
--@Episódio 28:  Caso encontremos uma ocorrência do léxico atual no texto, um link será montado e colocado na tabela links lexico, na mesma posição que o léxico atual ocupa na tabela lexicos e sinônimos.
							if (lexicos_e_sinonimos[i]["LEXICO"] ~= nil) then
								nome_lexico_link = lexicos_e_sinonimos[i]["LEXICO"];
							else
								nome_lexico_link = nome_lexico;
							end	
							link = "<a title=\"Léxico\" href=\"../visao/exibe_lexico.lp?id_projeto="..id_projeto.."&nome="..nome_lexico_link.."\">"..nome_lexico.."</a>";
							table.insert(tabela_links_lexico, i, link);
						end --if
						i = i + 1;
						
					else --if
--@Episódio 29:  Se o título do cenário atual possui um maior de palavras que o nome do léxico atual, então procuraremos a ocorrência deste cenário no texto
						titulo_cenario = cenarios[j]["TITULO"];
						
						expressao_regular = "("..titulo_cenario..")";
						
						if( string.gfind(texto, expressao_regular) ~= nil ) then
						
--@Episódio 28:  Caso encontremos uma ocorrência do cenário atual no texto, um link será montado e colocado na tabela links cenário, na mesma posição que o cenário atual ocupa na tabela cenários.						
							link = "<a title=\"Cenário\" href=\"../visao/exibe_cenario.lp?id_projeto="..id_projeto.."&titulo="..titulo_cenario.."\">"..titulo_cenario.."</a>";
							table.insert(tabela_links_cenario, j, link);
							texto = string.gsub(texto, expressao_regular, "wzczxk"..j.."kxyyc");
						
							
						end --if
						j = j + 1;
					
					end --if
				
				elseif( tam_lexicos_e_sinonimos == i-1 ) then
				
--@Episódio 28:  Se a tabela de léxicos chegou ao fim e a tabela cenários ainda possui cenários que não foram procurados, então devemos continuar percorrendo a tabela cenários.			 
					titulo_cenario = cenarios[j]["TITULO"];
					
					expressao_regular = "("..titulo_cenario..")";
					
					if( string.gfind(texto, expressao_regular) ~= nil ) then
					
--@Episódio 29:  Caso seja encontrada uma ocorrência do cenário atual no texto, um link será montado e inserido na tabela de links cenário. 	
						link = "<a title=\"Cenário\" href=\"../visao/exibe_cenario.lp?id_projeto="..id_projeto.."&titulo="..titulo_cenario.."\">"..titulo_cenario.."</a>";
						table.insert(tabela_links_cenario, j, link);
						texto = string.gsub(texto, expressao_regular, "wzczxk"..j.."kxyyc"); 						
							
					end --if
					
				elseif( tam_cenarios == j-1 )	then

--@Episódio 30:  Se a tabela de cenários chegou ao fim e a tabela léxicos e sinônimos ainda possui léxicos e sinônimos que não foram procurados, então devemos continuar percorrendo a tabela léxico e sinônimos.						
					nome_lexico = lexicos_e_sinonimos[i]["NOME"];
					
					expressao_regular = "("..nome_lexico..")";
					
					if( string.gfind(texto, expressao_regular) ~= nil ) then

--@Episódio 31:  Caso seja encontrada uma ocorrência do léxico atual no texto, um link será montado e inserido na tabela de links léxicos. 	
						texto = string.gsub(texto, expressao_regular, "wzzxk"..i.."kxy");
						if (lexicos_e_sinonimos[i]["LEXICO"] ~= nil) then
							nome_lexico_link = lexicos_e_sinonimos[i]["LEXICO"];
						else
							nome_lexico_link = nome_lexico;
						end	
						link = "<a title=\"Léxico\" href=\"../visao/exibe_lexico.lp?id_projeto="..id_projeto.."&nome="..nome_lexico_link.."\">"..nome_lexico.."</a>";
						table.insert(tabela_links_lexico, i, link); 
							
					end --if
					
					i = i + 1;
				
				end --if
				contador = contador + 1;
			
			end --while
			
		end --if
	end--if
	
	contador = 1;

--@Episódio 32:  A tabela links lexico é percorrida e os códigos inseridos anteriormente nos texto são substituidos pelos links armazenados na tabela. O número que está no meio do código corresponde a posição na tabela de links que o link que será inserido se encontra.
	for i, link in pairs(tabela_links_lexico) do
		expressao_regular = ("wzzxk"..i.."kxy");
		texto = string.gsub(texto, expressao_regular, link);
	end
--@Episódio 31:  A tabela links cenários é percorrida e os códigos inseridos anteriormente nos texto são substituidos pelos links armazenados na tabela. O número que está no meio do código corresponde a posição na tabela de links que o link que será inserido se encontra.
	for i, link in pairs(tabela_links_cenario) do
		expressao_regular = ("wzczxk"..i.."kxyyc");
		texto = string.gsub(texto, expressao_regular, link);
	end
--@Episódio 32:  O texto com os links é exibido para o usuário.
	cgilua.put(texto);	
	
end	

	







