<%	
	sessao = cgilua.session.load("1")
	if (sessao == nil) then
		cgilua.redirect("http://139.82.24.94:8080/cel/visao/index.html");
	end
%>	

<html>
<head>
	  <link rel="stylesheet" type="text/css" href="css/estilo.css" />
	  <title>C&L - Cen�rios e L�xicos</title> 
</head>

<body>

<table border=0>
	<tr>
		<td>
			<span class=titulomedio> Selecione um projeto existente ou crie um novo projeto para come�ar a utilizar o C&L.</span>
			<br />
			<hr>
			<br />
		</td>
	</tr>
</table>

<body>
</html>