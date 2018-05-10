dofile("../dao/projeto_dao.lua");
dofile("../dao/cenario_dao.lua");
dofile("../dao/lexico_dao.lua");
require("md5.core");


--[[
@Titulo:  Selecionar projeto.
@Objetivo: Obter as informa��es sobre um projeto espec�fico
@Contexto: A camada controle chama a fun��o selecionar_projeto.
@Atores: browser e usu�rio.
@Recursos: projeto_dao.lua.
]]--

function selecionar_projeto (id_projeto)

--@Epis�dio 1: SELECIONAR PROJETO DO BANCO DE DADOS.
	projeto = selecionar_projeto_bd(id_projeto);

--@Epis�dio 2: Retorna informa��es do projeto
	return projeto;

end


--[[
@Titulo:  Selecionar projetos.
@Objetivo: Selecionar todos os projetos de um determinado usu�rio.
@Contexto: A camada controle chama a fun��o selecionar_projetos.
@Atores: browser e usu�rio.
@Recursos: projeto_dao.lua.
]]--


function selecionar_projetos (id_usuario)

--@Epis�dio 1: SELECIONAR PROJETOS DO BANCO DE DADOS.
	projetos = selecionar_projetos_bd (id_usuario);

--@Epis�dio 2: Retorna a lista de projetos.
	return projetos;

end

--[[
@Titulo: Cadastrar projeto.
@Objetivo: Cadastrar o projeto no sistema
@Contexto: O usu�rio submete o formul�rio de cadastro de projeto.
@Atores: usu�rio.
@Recursos:  projeto_dao.lua
]]--

function cadastrar_projeto(nome, descricao, id_usuario)

--@Epis�dio 1: Obt�m do sistema a data em que esta sendo feito o cadastro.
	data = os.date("%Y-%m-%d %H:%M:%S"); 
	
--@Epis�dio 2: INSERIR PROJETO NO BANCO DE DADOS
	inserir_projeto_bd(nome, descricao, data, id_usuario);

end 

--[[
@Titulo: Contar palavras.
@Objetivo: Recebe um texto como par�metro e retorna o n�mero de palavras que comp�e o texto.
@Contexto: a fun��o conta_palavras � chamada
@Atores: usu�rio.
@Recursos:  
]]--

function conta_palavras(texto)

--@Epis�dio 1: Inicializa o contador com o valor 0.
	contador_palavras = 0;

--@Epis�dio 2: Para cada caracter alfanumerico segui de um ou mais caracteres alfan�mericos (%w+) o contador de palavras � incrementado de 1.	
	for palavra in string.gmatch(texto, "%w+") do
		contador_palavras = contador_palavras+1;
	end
	
--@Epis�dio 3: Retorna o contador de palavras
	return contador_palavras;
end

--[[
@Titulo: Particionar tabela.
@Objetivo: Organizar a tabela, escolher o piv� e particiona-la (partition do quicksort).
@Contexto: a fun��o particao � chamada
@Atores: usu�rio.
@Recursos:  
]]--

function particao( elementos, inicio, fim, tipo )
	
--@Epis�dio 1: Inicializa as vari�veis i, j e dir.
    i = inicio;
    j = fim;
    dir = 1;
    
    while( i < j ) do
	
--@Epis�dio 2: Enquanto i < j percorre a tabela elementos.
    	if(tipo == "cenario") then

--@Epis�dio 3: Se tipo igual a cen�rio, ent�o se CONTA PALAVRAS do elemento na posi��o i for menor que CONTA PALAVRAS do elemento na posi��o j, ent�o eles s�o trocados.
    		if( conta_palavras( elementos[i]["TITULO"] ) < conta_palavras( elementos[j]["TITULO"] ) ) then
	        
				temporario = elementos[i];
	            elementos[i] = elementos[j];
	            elementos[j] = temporario;
	            dir = dir -1;
	        end	
    	
		else
--@Epis�dio 4: Se tipo igual a lexico, ent�o se CONTA PALAVRAS do elemento na posi��o i for menor que CONTA PALAVRAS do elemento na posi��o j, ent�o eles s�o trocados.	    
			if( conta_palavras( elementos[i]["NOME"] ) < conta_palavras( elementos[j]["NOME"] ) ) then
	        
				temporario = elementos[i];
	            elementos[i] = elementos[j];
	            elementos[j] = temporario;
	            dir = dir - 1;
			end	
				
	  	end
--@Epis�dio 5: Se n�o houve nenhuma troca, isto �, se dir diferente igual a 1, ent�o a vari�vel j � decrementada de 1, sen�o a vari�vel i � incrementada de 1.
        if( dir == 1 ) then
            j = j - 1;
        else
            i = i + 1;
		end	
    end
--@Epis�dio 6: Retorna o valor da vari�vel i.
    return i;
	
end

--[[
@Titulo: Ordenar a tabela.
@Objetivo: Ordena a tabela colocando as palavras compostas de mais palavras na frente.
@Contexto: a fun��o ordena_tabela � chamada
@Atores: usu�rio.
@Recursos:  
]]--


function ordena_tabela(tabela, inicio, fim, tipo )

    
	if( inicio < fim ) then
--@Epis�dio 1:  Se inicio < fim, ent�o PARTICIONAR TABELA
        pivo = particao(tabela, inicio, fim, tipo );
		
--@Epis�dio 2: Chama recursivamente a funcao ordena_tabela para a primeira  metade da tabela.
	    ordena_tabela( tabela, inicio, pivo-1, tipo );
		
--@Epis�dio 3: Chama recursivamente a funcao ordena_tabela para a segunda  metade da tabela.
        ordena_tabela( tabela, pivo+1, fim, tipo );
    
	end
	
--@Epis�dio 4: retorna a tabela ordenada
	return tabela;
	
end	

--[[
@Titulo: Colocar links
@Objetivo: Procurar o texto passado por par�metro qualquer refer�ncia a elementos do projeto passado por par�metro. Caso encontre alguma ocorr�ncia, substitui o termo encontrado por um link para sua defini��o.
@Contexto: a fun��o coloca_links � chamada
@Atores: usu�rio.
@Recursos:  
]]--

	
function coloca_links (id_projeto, texto, tipo)


--@Epis�dio 1: SELECIONAR TODOS OS LEXICOS DO BANCO DE DADOS
	lexicos = selecionar_todos_lexicos_bd(id_projeto);
	
--@Epis�dio 2: SELECIONAR TODOS OS SIN�NIMOS DO BANCO DE DADOS
	sinonimos = selecionar_sinonimos_projeto_bd(id_projeto);

--@Epis�dio 3: SELECIONAR TODOS OS CEN�RIOs DO BANCO DE DADOS
	cenarios = selecionar_todos_cenarios_bd(id_projeto);
	
--@Epis�dio 4: Monta uma tabela �nica com l�xicos e sin�nimos	
	for index, sinonimo in pairs(sinonimos) do
		table.insert(lexicos, sinonimo);
	end 
	lexicos_e_sinonimos = lexicos;
	
--@Epis�dio 5: ORDENAR TABELA sinonimos.
	sinonimos = ordena_tabela(sinonimos, 1, table.maxn(sinonimos) ,"lexico" )
	
--@Epis�dio 6: ORDENAR TABELA cen�rios
	cenarios =  ordena_tabela(cenarios, 1, table.maxn(cenarios) ,"cenario" )
	
--@Epis�dio 7: ORDENAR TABELA lexicos_e_sinonimos.	
	lexicos_e_sinonimos = ordena_tabela(lexicos_e_sinonimos, 1, table.maxn(lexicos_e_sinonimos),"lexico" )
	
--@Epis�dio 8: O tamanho da tabela lexicos_e_sinonimos � armazenado na vari�vel tam_lexicos_e_sinonimos
	tam_lexicos_e_sinonimos = #lexicos_e_sinonimos;
	
--@Epis�dio 9: O tamanho da tabela cenarios � armazenado na vari�vel tam_cenarios
	tam_cenarios = #cenarios;
	
--@Epis�dio 10: O tamanho da tabela tam_lexicos_e_sinonimos somado com o tamanho da tabela cenarios � armazenado na vari�vel tam_total
	tam_total = tam_lexicos_e_sinonimos + tam_cenarios ;
	
--@Epis�dio 11: Cria tabelas que armazenar�o os links criados para l�xicos e para cen�rios.	
	tabela_links_lexico = {};
	tabela_links_cenario = {};
		

	if ((tipo == "lexico") or (tam_cenarios == 0)) then
--@Epis�dio 12: Se n�o h� cen�rios no projeto ent�o percorreremos apenas a lista de lexicos e sin�nimos.
		for index, lexico in pairs(lexicos_e_sinonimos) do

--@Epis�dio 13: A vari�vel nome_lexico recebe o nome do l�xico ou sin�nimo atual.
			nome_lexico = lexico["NOME"];
			
--@Epis�dio 14: Uma express�o regular � montada com a vari�vel nome_lexico e armazenada na vari�vel expressao_regular			
			expressao_regular = "("..nome_lexico..")";

			if (string.find(texto, expressao_regular) ~= nil) then
--@Epis�dio 15: Se alguma ocorr�ncia de express�o regular for encontrada no texto, ent�o est� express�o � subistituida por um c�digo (wzzxkkxy) seguido da posi��o do l�xico na tabela lexicos e sinonimos
				texto = string.gsub(texto, expressao_regular, "wzzxk"..index.."kxy");

--@Epis�dio 16: verifica se a expressao encontrada � realmente um l�xico ou � um sin�nimo de um l�xico 
				if (lexico["LEXICO"] ~= nil) then
				
--@Epis�dio 16: Se a express�o encontrada for um sin�nimo ent�o o nome_lexico_link deve ser o nome do l�xico a que pertence o sin�nimo
					nome_lexico_link = lexico["LEXICO"]
				else
				
--@Epis�dio 16: Se a express�o encontrada for um l�xico ent�o o nome_lexico_link deve ser o nome do l�xico.
					nome_lexico_link = nome_lexico;
				end	
--@Epis�dio 18:  Monta o link da express�o encontrada
				link = "<a title=\"L�xico\" href=\"../visao/exibe_lexico.lp?id_projeto="..id_projeto.."&nome="..nome_lexico_link.."\">"..nome_lexico.."</a>";

--@Epis�dio 19: insere o link na tabela de links lexico na posi��o em que o elemento encontrado ocupa na tabela lexicos_e_sinonimos. 
				table.insert(tabela_links_lexico, index, link);
			end --if
				
	    end --for
	
	else	
	
		if (tam_lexicos_e_sinonimos == 0 and tam_cenarios > 0) then
		
--@Epis�dio 20: Se n�o h� l�xicos no projeto ent�o percorreremos apenas a lista de cen�rios
			for index, cenario in pairs(cenarios) do
			
--@Epis�dio 21: A vari�vel nome_cenario recebe o t�tulo do cen�rio atual	
		        nome_cenario = cenario["TITULO"];
				
--@Epis�dio 22: Uma express�o regular � montada com a vari�vel nome_cenario e armazenada na vari�vel expressao_regular
				expressao_regular = "("..nome_cenario..")";
							
				if (string.find(texto, expressao_regular) ~= nil) then
				
--Epis�dio 23: Se alguma ocorr�ncia de express�o regular for encontrada no texto, ent�o um link � montado com o nome do cen�rio
					link = "<a title=\"Cen�rio\" href=\"../visao/exibe_cenario.lp?id_projeto="..id_projeto.."&titulo="..titulo_cenario.."&comando=exibir\">"..titulo_cenario.."</a>";
					
--Epis�dio 23: O link montado � inserido na tabela links cen�rio na posi��o que o cen�rio encontrado ocupa na tabela cen�rios
					table.insert(tabela_links_cenario, index, link);
					
--@Epis�dio 24:  A express�o regular � subistituida por um c�digo (wzzxkkxyyc) seguido da posi��o do cenario na tabela cenarios
					texto = string.gsub(texto, expressao_regular, "wzczxk"..i.."kxyyc");
				end --if
				
		    end	-- for
		
		elseif (tam_total > 0) then
			
			--Se o vetor de cen�rios n�o estiver vazio ele ir� procurar por l�xicos e cen�rios
			i = 1;
			j = 1;
					
			contador = 1;
--@Epis�dio 25:  Se o projeto possuir cen�rios e l�xicos, ent�o as listas de l�xicos e cen�rios ser�o percorridas.
			while (contador <= tam_total) do
						
				if ( ( i <= tam_lexicos_e_sinonimos ) and (j <= tam_cenarios) ) then
					
--@Epis�dio 26:  Se a lista de cen�rios n�o chegou ao fim e a lista de l�xicos tamb�m n�o chegou ao fim ent�o CONTAR PALAVRAS do titulo do cen�rio e CONTAR PALAVRAS do nome do l�xico
					if ( conta_palavras(cenarios[j]["TITULO"]) <= conta_palavras(lexicos_e_sinonimos[i]["NOME"]) ) then
					    
--@Epis�dio 27:  Se o t�tulo do cen�rio atual possui um n�mero menor ou igual de palavras que o nome do l�xico, ent�o procuraremos a ocorr�ncia deste l�xico no texto
						nome_lexico = lexicos_e_sinonimos[i]["NOME"];
					
						expressao_regular = "("..nome_lexico..")";
						
						if( string.gfind(texto, expressao_regular) ~= nil ) then
						
							texto = string.gsub(texto, expressao_regular, "wzzxk"..i.."kxy");
							
--@Epis�dio 28:  Caso encontremos uma ocorr�ncia do l�xico atual no texto, um link ser� montado e colocado na tabela links lexico, na mesma posi��o que o l�xico atual ocupa na tabela lexicos e sin�nimos.
							if (lexicos_e_sinonimos[i]["LEXICO"] ~= nil) then
								nome_lexico_link = lexicos_e_sinonimos[i]["LEXICO"];
							else
								nome_lexico_link = nome_lexico;
							end	
							link = "<a title=\"L�xico\" href=\"../visao/exibe_lexico.lp?id_projeto="..id_projeto.."&nome="..nome_lexico_link.."\">"..nome_lexico.."</a>";
							table.insert(tabela_links_lexico, i, link);
						end --if
						i = i + 1;
						
					else --if
--@Epis�dio 29:  Se o t�tulo do cen�rio atual possui um maior de palavras que o nome do l�xico atual, ent�o procuraremos a ocorr�ncia deste cen�rio no texto
						titulo_cenario = cenarios[j]["TITULO"];
						
						expressao_regular = "("..titulo_cenario..")";
						
						if( string.gfind(texto, expressao_regular) ~= nil ) then
						
--@Epis�dio 28:  Caso encontremos uma ocorr�ncia do cen�rio atual no texto, um link ser� montado e colocado na tabela links cen�rio, na mesma posi��o que o cen�rio atual ocupa na tabela cen�rios.						
							link = "<a title=\"Cen�rio\" href=\"../visao/exibe_cenario.lp?id_projeto="..id_projeto.."&titulo="..titulo_cenario.."\">"..titulo_cenario.."</a>";
							table.insert(tabela_links_cenario, j, link);
							texto = string.gsub(texto, expressao_regular, "wzczxk"..j.."kxyyc");
						
							
						end --if
						j = j + 1;
					
					end --if
				
				elseif( tam_lexicos_e_sinonimos == i-1 ) then
				
--@Epis�dio 28:  Se a tabela de l�xicos chegou ao fim e a tabela cen�rios ainda possui cen�rios que n�o foram procurados, ent�o devemos continuar percorrendo a tabela cen�rios.			 
					titulo_cenario = cenarios[j]["TITULO"];
					
					expressao_regular = "("..titulo_cenario..")";
					
					if( string.gfind(texto, expressao_regular) ~= nil ) then
					
--@Epis�dio 29:  Caso seja encontrada uma ocorr�ncia do cen�rio atual no texto, um link ser� montado e inserido na tabela de links cen�rio. 	
						link = "<a title=\"Cen�rio\" href=\"../visao/exibe_cenario.lp?id_projeto="..id_projeto.."&titulo="..titulo_cenario.."\">"..titulo_cenario.."</a>";
						table.insert(tabela_links_cenario, j, link);
						texto = string.gsub(texto, expressao_regular, "wzczxk"..j.."kxyyc"); 						
							
					end --if
					
				elseif( tam_cenarios == j-1 )	then

--@Epis�dio 30:  Se a tabela de cen�rios chegou ao fim e a tabela l�xicos e sin�nimos ainda possui l�xicos e sin�nimos que n�o foram procurados, ent�o devemos continuar percorrendo a tabela l�xico e sin�nimos.						
					nome_lexico = lexicos_e_sinonimos[i]["NOME"];
					
					expressao_regular = "("..nome_lexico..")";
					
					if( string.gfind(texto, expressao_regular) ~= nil ) then

--@Epis�dio 31:  Caso seja encontrada uma ocorr�ncia do l�xico atual no texto, um link ser� montado e inserido na tabela de links l�xicos. 	
						texto = string.gsub(texto, expressao_regular, "wzzxk"..i.."kxy");
						if (lexicos_e_sinonimos[i]["LEXICO"] ~= nil) then
							nome_lexico_link = lexicos_e_sinonimos[i]["LEXICO"];
						else
							nome_lexico_link = nome_lexico;
						end	
						link = "<a title=\"L�xico\" href=\"../visao/exibe_lexico.lp?id_projeto="..id_projeto.."&nome="..nome_lexico_link.."\">"..nome_lexico.."</a>";
						table.insert(tabela_links_lexico, i, link); 
							
					end --if
					
					i = i + 1;
				
				end --if
				contador = contador + 1;
			
			end --while
			
		end --if
	end--if
	
	contador = 1;

--@Epis�dio 32:  A tabela links lexico � percorrida e os c�digos inseridos anteriormente nos texto s�o substituidos pelos links armazenados na tabela. O n�mero que est� no meio do c�digo corresponde a posi��o na tabela de links que o link que ser� inserido se encontra.
	for i, link in pairs(tabela_links_lexico) do
		expressao_regular = ("wzzxk"..i.."kxy");
		texto = string.gsub(texto, expressao_regular, link);
	end
--@Epis�dio 31:  A tabela links cen�rios � percorrida e os c�digos inseridos anteriormente nos texto s�o substituidos pelos links armazenados na tabela. O n�mero que est� no meio do c�digo corresponde a posi��o na tabela de links que o link que ser� inserido se encontra.
	for i, link in pairs(tabela_links_cenario) do
		expressao_regular = ("wzczxk"..i.."kxyyc");
		texto = string.gsub(texto, expressao_regular, link);
	end
--@Epis�dio 32:  O texto com os links � exibido para o usu�rio.
	cgilua.put(texto);	
	
end	

	







