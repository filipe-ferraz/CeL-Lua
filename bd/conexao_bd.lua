require"luasql.mysql"

--[[
@Titulo: Conectar ao banco de dados.
@Objetivo:Retonar uma conex�o com o banco de dados
@Contexto: a fun��o conectar_bd � chamada.
@Atores: Banco de dados.
@Recursos: luasql.mysql.
]]--

--@Epis�dio 1: Os atributos da conex�o s�o configurados.
nome_bd = "nomedobd";
login = "seulogin";
senha = "suasenha";
endereco = "localhost";
porta = "3306";

function conectar_bd ()

--@Epis�dio 2: O ambiente � criado.
	local ambiente = luasql.mysql ()
--@Epis�dio 3: Uma conex�o � aberta com as configura��es desejadas.
	local conexao = assert (ambiente:connect (nome_bd, login, senha, endereco, porta));
--@Epis�dio 4: A conex�o � retornada.
	return conexao;

end
