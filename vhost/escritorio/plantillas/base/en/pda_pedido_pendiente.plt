<html>
<head>
<title>{{label_pedidospendientes}}</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../estilos.css" type="text/css">
<link rel="stylesheet" href="../gestion/estilos.css" type="text/css">
<link rel="stylesheet" href="../gestion/estilos.css" type="text/css">
<link rel="stylesheet" href="../gestion/estilos.css" type="text/css">
<link rel="stylesheet" href="../gestion/estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form method="post" action="?seccion=@%env:_krn_ss_name;%@">
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">{{label_inmersaempresa}}: {{label_icfv}}</td>
 </tr>
<tr> <td class="accesos" align="right"></td>
 </tr>

</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="68">{{label_cliente}}</td>
</tr>
<tr> <td class="titul1" align="left" width="68">{{fld_nombre}}:</td>
 <td width="132"> {{fld_nombre}}</td>
 </tr>

<tr>
<td height="20"></td>
</tr>
</table>

 <table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="154">{{label_pedidopendiente}}</td>
 </tr>
 <tr>
 <td align="left" class="accesos" width="154">{{label_referencia}} </td>
 <td align="left" width="154">{{label_fecha}} </td>
 </tr>
 <tr>
 <td align="left" class="titul1" width="154"> {{label_baseimponible}}</td>
 <td align="left" width="46"> {{label_euros}}</td>
 </tr>
 <tr>
<td height="20"></td>
</tr>
</table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td class="accesos2" align="left" width="132">{{label_mercanciasnoservidas}}</td>
 </tr>
 <tr>
<td height="10"></td>
</tr>
 </table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td class="titul1" align="left" width="132">>{{label_idarticulo}}</td>
 <td class="titul1" align="left" width="68">{{fld_nombre}}</td>
 </tr>
 <tr>
 <td class="texto" align="left" width="132">{{label_cantidadpedida}}</td>
 <td class="texto" align="left" width="68">{{label_numero}}</td>
 </tr>
 <tr>
 <td class="texto" align="left" width="132">{{label_cantidadservida}}</td>
 <td class="texto" align="left" width="68">{{label_numero}}</td>
 </tr>
 <tr>
 <td class="texto" align="left" width="132">{{label_fechaestimada}}</td>
 <td class="texto" align="left" width="68">{{label_numero}}</td>
 </tr>
 <tr>
<td height="10"></td>
</tr>
 </table>



<table width="200" border="0" cellspacing="0" cellpadding="0">

<tr> <td class="accesos" align="right">{{acc_volver}}</td>
 </tr>

<tr>
<td height="10"></td>
</tr>
 </table>

</form>
</body>
</html>

