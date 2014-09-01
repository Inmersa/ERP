<html>
<head>
<title>{{pda_direcciones_entrega.plt0}}</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form method="post" action="?seccion=@%env:_krn_ss_name;%@">
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">Inmersa Empresa: i-CFV</td>
 </tr>
<tr> <td class="accesos" align="right"></td>
 </tr>

</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="68">Direcciones entrega</td>
</tr>
<tr>
<td height="20"></td>
</tr>
</table>

<table width="200" border="0" cellspacing="0" cellpadding="0">

<tr> <td class="titocho" align="left" width="68">Cliente: </td>
 <td width="132">@%db:Clientes.razon_social;%@</td>
 </tr>
<tr>
<td height="20"></td>
</tr>
</table>

@%where:tabla|Direcciones_entrega;%@
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> <td class="titul1" align="left" width="84">Dir. entrega:</td>
 <td width="116">@%db:Direcciones_entrega.direccion%@</td>
 </tr>

<tr> <td class="titul1" align="left" width="84">Población:</td>
 <td width="116"> @%db:Direcciones_entrega.poblacion%@</td>
 </tr>
<tr> <td class="titul1" align="left" width="84">Teléf<span class="titul1">o</span>No:</td>
 <td width="116"> @%db:Direcciones_entrega.telefono1%@</td>
 </tr>
<tr> <td class="titul1" align="left" width="84">CP:</td>
 <td width="116"> @%db:Direcciones_entrega.cp%@</td>
 </tr>
<tr>
 <td height="10" width="84"></td>
</tr>
</table>
@%end-where:%@

<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> <td class="accesos" align="right"><a href="?seccion=pda_cliente" class="accesos">Volver</a></td>
 </tr>

<tr>
<td height="10"></td>
</tr>
 </table>
</form>
</body>
</html>

