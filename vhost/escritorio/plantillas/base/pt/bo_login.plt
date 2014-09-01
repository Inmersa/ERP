<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>Identificação necessária</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="modulos/temas/inmersa/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/login.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/bordescolores.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/tipografia.css" type="text/css" media="screen" >

<link rel="stylesheet" href="modulos/temas/personalizaciones/eurociber/login.css" type="text/css" media="screen" >
<link rel="SHORTCUT ICON" href="imag/imagotipo.png">

</head>
<body >

<div id="pagina" style="left: 30%; position: relative;">
 <div id="logoempresa" ><img src="imag/pxt.gif" class="null"/></div>
<div id="login">
 <div class="fondotela" ><img name="araña" src="imag/login/arana.png" border="0"></div>
 <div id="logoproducto" class="internacional"><img src="imag/pxt.gif" class="null"/></div>
 <div id="logomodulo" class="internacional"><img src="imag/pxt.gif" class="null"/></div>

 <form method="post" action="?@%get:_krn_ss_querystring;%@">
 <input type="hidden" name="iface" value="nav" />
 <table >
 <tr><td class="titocho" align="right">Idioma:</td>
 <td align="left" ><select name="lang" class="insertext">
 <option value="">PreDef</option>
 @%where:db|conf;tabla|Idiomas;%@
<option value="@%db:Idiomas.nemonico;%@">@%db:Idiomas.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>

 <tr><td class="titocho" align="right">Utilizador:</td>
 <td align="left" ><input type="text" border="cccccc" name="user" class="insertext" size="20"></td>
 </tr>

 <tr><td class="titocho" align="right">Palavra-Passe:</td>
 <td align="left" ><input type="password" border="cccccc" name="pass" class="insertext" size="20"></td>
 </tr>
 <tr><td colspan="2" align="center"
 	><input type="image" value="Enviar" name="submit" src="imag/login/boton-login.png" class="insertext"></td></tr>
 </table>
 <div id="version" >V. 2.0-a2</div>
 <div id="logoinmersa" class="internacional" ><img src="imag/pxt.gif" class="null"></div>
 <div id="copyright" >Copyright 2003. Inmersa Technologies. All rights reserved</div>

</form>
</div></div>

</body>
</html>
