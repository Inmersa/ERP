<html>
<head>
<title>Close Day Work</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form method="post" action="?seccion=pda_clientes_ruta" name="cierre_ruta">
<input type="hidden" name="accion_ejecutar" value="cerrar_recorrido">
<input type="hidden" name="registro[id_recorrido]" 
@%if:esta_vacio;id_recorrido_pda;%@
value="@%get:id_recorrido_act%@"
@%else:%@
value="@%get:id_recorrido_pda%@"
@%end-if:%@
>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">Inmersa Business: i-SFC</td>
 </tr>
<tr> <td class="accesos" align="right"><input type="submit" value="Close Route">
<!-- a href="javascript:document.forms['cierre_ruta'].submit();" class="accesos">Close Route</a --> </td>
 </tr>
<tr>
<td height="10"></td>
</tr>
</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left">Expenditures Route</td>
</tr>
@%where:tabla|Gastos;nolink|1;%@
<tr> <td class="acceso_directo" align="left">@%db:Gastos.nombre%@ :</td>
 <td> <input type="text" border="cccccc" name="gastos[@%db:Gastos.id_gasto%@][importe]" class="insertext" size="10">
 </td>
 </tr>
@%end-where:%@

</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">

<tr> <td class="acceso_directo" align="left">Route Remarks:</td>
 </tr>

<tr>
 <td> <textarea border="cccccc" name="registro[observaciones]" class="insertext" cols="24"></textarea>
 </td>
 </tr>
<tr>
<td height="10"></td>
</tr>
</table>

<table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td class="accesos2" align="left">Next route date</td>
 </tr>
 <tr>
 <td align="center"> <input type="text" border="cccccc" name="registro[prox_fecha]" class="insertext" size="20">
 </td>
 <tr>
<td height="10"></td>
</tr>
 </table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> <td class="accesos" align="right"><input type="submit" value="Close Route">
<!-- a href="javascript:document.forms['cierre_ruta'].submit();" class="accesos">Close Route</a --> </td>
 </tr>
 </table>

</form>
</body>
</html>

