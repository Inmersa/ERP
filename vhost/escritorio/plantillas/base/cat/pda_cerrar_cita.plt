<html>
<head>
<title>Tancar</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form method="post" action="?seccion=pda_clientes_ruta" name="cita">
<input type="hidden" name="accion_ejecutar" value="cerrar_cita">
<input type="hidden" name="registro[id_cita]" value="@%db:Citas.id_cita%@">
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">Inmersa Empresa: i-CFV</td>
 </tr>
<tr> <td class="accesos" align="right"></td>
 </tr>

</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="68">Client</td>
</tr>
<tr> <td class="titul1" align="left" width="68">Nom:</td>
 <td width="132" class="texto" > @%db:Clientes.razon_social%@</td>
 </tr>



<tr>
<td height="10"></td>
</tr>
</table>


<table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td class="titocho" align="left" width="92">Visitat</td>
 <td class="titocho" align="left" width="108"> <input type="checkbox" name="registro[visitado]" value="1">
</td>
 </tr>
 <tr>
 <td align="left" class="insertext" width="92">Mig</td>
 <td width="108"> <select name="registro[id_medio_cto]" size="1">
 @%where:tabla|Medios_contacto;nolink|1;%@
 <option value="@%db:Medios_contacto.id_medio_cto%@">@%db:Medios_contacto.nombre%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr>
 <td height="10" width="92"></td>
</tr>
 </table>
 
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td align="left" class="titocho" width="123">Observacions Cita</td>
 </tr>
 

<tr>
 <td> <textarea border="cccccc" name="registro[observaciones]" class="insertext" cols="24"></textarea>
 </td>
 </tr>
 <tr>
<td height="20"></td>
</tr>
 </table>

<table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td align="left" class="insertext" width="123">Preview</td>
 <td>@%db:DATE_ADD(Recorridos.fecha,INTERVAL Rutas.d_frecuencia DAY) as 'fecha_prevista'%@
 <!-- @%db:Rutas.nombre%@ -->
 </td>
 </tr>
 <tr>
 <td align="left" class="insertext" width="123">Próxima data visita</td>
 <td> <input type="text" border="cccccc" name="registro[prox_fecha]" class="insertext" size="10">
 </td>
 </tr>
 <tr>
<td height="10"></td>
</tr>
</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td align="left" class="titocho" width="123">Comentari próxim Cita</td>
 </tr>
<tr>
 <td> <textarea border="cccccc" name="registro[prox_comentario]" class="insertext" cols="24"></textarea>
 </td>
 </tr>
 <tr>
<td height="20"></td>
</tr>
</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <tr>
 <td align="left" class="insertext" width="123">Mig próxim Cita</td>
 <td> <select name="registro[prox_id_medio_cto]" size="1">
 @%where:tabla|Medios_contacto;nolink|1;%@
 <option value="@%db:Medios_contacto.id_medio_cto%@">@%db:Medios_contacto.nombre%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 
 <tr>
<td height="10"></td>
</tr>
 </table>

 
<table width="200" border="0" cellspacing="0" cellpadding="0">

<tr> <td class="accesos" align="right"><!-- a href="javascript:document.forms['cita'].submit();" class="accesos">Tancar</a --><input type="submit" 
value="Tancar"></td>
 </tr>

<tr>
<td height="10"></td>
</tr>
 </table>

</form>
</body>
</html>

