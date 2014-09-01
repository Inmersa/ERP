<html>
<head>
<title>Confirmar pedido</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
@%if:esta_vacio;id_cita_pda;%@
<form method="post" action="?seccion=pda_clientes_ruta" name="confirmar_pedido">
<input type="hidden" name="accion_ejecutar" value="confirmar_pedido">
@%else:%@
<form method="post" action="?seccion=pda_cerrar_cita" name="confirmar_pedido">
<input type="hidden" name="Confirmar" value="1">
@%end-if:%@
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">Inmersa Empresa: i-CFV</td>
 </tr>
<tr> <td class="accesos" align="right"><!-- a href="javascript:document.forms['confirmar_pedido'].submit();"
class="accesos">Confirmar</a--><input type="submit" value="Confirmar"><a href="?seccion=pda_hacer_pedido" class="accesos"
>Volver</a></td>
 </tr>
<tr>
<td height="10"></td>
</tr>
</table>

<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="68">Cliente</td>
</tr>
<tr> <td class="titul1" align="left" width="68">Nombre:</td>
 @%where:nodb|nodb_reciever_data;%@ 
 <td width="132" class="texto"> @%db:razon_social%@</td>
@%end-where:%@

 </tr>
<tr>
<td height="10"></td>
</tr>
</table>

@%where:nodb|nodb_order_data;%@
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> <td class="titul1" align="left" width="95">&gt; Direcciones de entrega</td>
</tr>
 <tr>
 <td height="10"></td>
 </tr>
 </table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> <td align="center" width="90"> <select name="registro[id_direccion]" class="insertext">
 @%set:_selected_value=id_direccion_cliente;%@
@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_cliente = $id_cliente_pedido;%@
<option value="@%db:Direcciones_entrega.id_direccion;%@"
@%db:selected_value{Direcciones_entrega.id_direccion}%@
>@%db:Direcciones_entrega.nombre;%@ @%db:Direcciones_entrega.direccion;%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 

<tr>
 <td height="10" width="90"></td>
</tr>
</table>


 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td align="left" class="titul1" width="114">Forma de pago</td>
 <td class="texto" width="86">
@%set:forma_pago=id_forma_pago%@
@%where:tabla|Forma_pago;nolink|1;where|id_forma_pago = $forma_pago;%@
@%db:Forma_pago.nombre;%@
 @%end-where:%@

</td>
 </tr>
<tr> <td align="left" class="titul1" width="114">Divisa</td>
 <td class="texto" width="86">
 @%set:divisa=id_divisa;%@
@%where:tabla|Divisa;nolink|1;where|id_divisa = $divisa;%@ 
@%db:Divisa.nombre;%@
 @%end-where:%@

</td>
 </tr>
 @%end-where:%@

<tr>
 <td height="10"></td>
 </tr>
 @%where:nodb|nodb_taxes_detail;%@ 
<tr> <td align="left" class="titul1" width="114">@%db:porcentaje%@% / @%db:porcentaje_recargo_equivalente%@%</td>
 <td class="texto" width="86">@%db:recargo_iva%@@%db:leyenda_divisa%@ / @%db:recargo_equivalente%@@%db:leyenda_divisa%@</td>
 </tr>
 @%end-where:%@

 <tr>
 <td height="10" width="114"></td>
 </tr>

 @%where:nodb|nodb_discounts_detail;%@
<tr> <td align="left" class="titul1" width="114">@%db:nombre%@</td>
 <td class="texto" width="86">@%db:descuento;%@ % @%db:importe%@ @%db:leyenda_divisa%@</td>
 </tr>
 @%end-where:%@

 @%where:nodb|nodb_order_totals;%@
 <tr>
 <td height="10" width="114"></td>
 </tr>
 <tr> <td align="left" class="titocho" width="114">Total Bruto:</td>
 <td class="texto" width="86">@%db:bruto%@ @%db:leyenda_divisa%@</td>
 </tr>
 <tr> <td align="left" class="titocho" width="114">Base imponible:</td>
 <td class="texto" width="86">@%db:base_imponible%@ @%db:leyenda_divisa%@</td>
 </tr>
 <tr> <td align="left" class="titocho" width="114">Retenciones:</td>
 <td class="texto" width="86">@%db:retenido%@ @%db:leyenda_divisa%@</td>
 </tr>
 <tr> <td align="left" class="titocho" width="97">Total Dtos.:</td>
 <td class="texto" width="103">@%db:descuentos%@ @%db:leyenda_divisa%@</td>
 </tr>
 <tr>
 <td height="10"></td>
 </tr>
 <tr> <td align="left" class="titocho" width="97">Importe:</td>
 <td class="texto" width="103">@%db:importe%@ @%db:leyenda_divisa%@</td>
 </tr>
 @%end-where:%@

 <tr>
 <td height="10"></td>
 </tr> </table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
<td class="titocho">Observaciones :</td>
</tr>
 <tr>
<td class="titocho"><textarea class="insertext" name="registro[observaciones]" rows="5" cols="30"></textarea></td>
</tr>
<tr> <td class="accesos" align="right"><!-- a href="javascript:document.forms['confirmar_pedido'].submit();"
class="accesos">Confirmar</a --><input type="submit" value="Confirmar"><a href="?seccion=pda_hacer_pedido" class="accesos"
>Volver</a></td>
 </tr>
</table>
</form>
</body>
</html>


