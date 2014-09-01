<html>
<head>
<title>{{label_hacerpedido}}</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr><td>
<form method="post" action="?seccion=@%env:_krn_ss_name;%@" name='hacer_pedido'>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">{{label_inmersaempresa}}: {{label_icfv}}</td>
 </tr>
<tr> <td class="accesos" align="right"><!-- a href="javascript: document.forms['cesta'].submit();" class="accesos">{{acc_finalizar}}</a --><input type="submit" 
name="Finalizar" value="{{acc_finalizar}}">
 <input type="submit" name="Anyadir" value="{{acc_anadir}}">
 <!-- a href="" onClick="document.forms['hacer_pedido'].submit();return false;"class="accesos">{{acc_anadir}}</a -->
 </td>
 </tr>
<tr>
<td height="10"></td>
</tr>
</table>

<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td class="accesos2" align="left" width="68">{{label_cliente}}</td>
</tr>
<tr> <td class="titul1" align="left" width="68">{{fld_nombre}}:</td>
 @%where:nodb|nodb_reciever_data;%@
 <td width="132" class="texto">@%db:razon_social%@ (@%db:id%@)</td>
 @%end-where:%@

 </tr>
<tr>
<td height="10"></td>
</tr>
</table>

<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> <td class="acceso_directo" align="center" width="95">{{label_id}}</td>
 <td class="acceso_directo" align="center" width="56">{{fld_cantidad}}</td>
 <td class="acceso_directo" align="center" width="49">{{label_bultos}}</td>
 </tr>
 </table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
@%set:_iterate_times=5%@
@%where:nodb|nodb_iterate;%@
<tr> <td align="center" width="90"> <input type="text" border="cccccc" name="array_ids[@%db:iterate_num;%@]" class="insertext" size="12">
 </td>
 <td align="center" width="59"> <input type="text" border="cccccc" name="array_numero[@%db:iterate_num;%@]" class="insertext" size="5">
 </td>
 <td class="titocho" align="center" width="51"> <input type="checkbox" name="array_bultos[@%db:iterate_num;%@]" value="1">
 </td>
 </tr>
 @%end-where:%@
 

<tr>
 <td height="10" width="90"></td>
</tr>
</table>

<table width="200" border="0" cellspacing="0" cellpadding="0">
 <td class="accesos2" align="left">{{label_articulosseleccionados}}<input type="submit" name="Anyadir" value="{{acc_anadir}}">
</td>
 <tr>
<td height="10"></td>
</tr>
 </table>
</form>
 <form name="cesta" method="post" action="?seccion=pda_confirmar_pedido">
<table width="200" border="0" cellspacing="0" cellpadding="0">
@%where:nodb|nodb_order_details;%@
 <input type="hidden" name="array_detalle[@%db:id_articulo%@]" value="@%db:id_detalle%@">
<input type="hidden" name="articulos_cesta[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@">
<tr> <td class="acceso_directo" align="center" width="27"> 
<input type="checkbox" name="articulos_confirmados[@%db:idx_detalle;%@]" value="@%db:idx_detalle;%@" 
@%if:esta_vacio;pda_check_them;%@
@%if:pda_confirmar_check;idx_detalle;%@
checked="checked"
@%end-if:%@
@%else:%@
checked="checked"
@%end-if:%@
>
 </td>
 <td class="texto" align="center" width="65">@%db:nombre%@</td>
 <td class="texto" align="center" width="108">@%db:id_articulo%@</td>
 </tr>
 <tr> <td class="texto" align="center" width="27">@%db:stock_estimado%@</td>
 <td class="texto" align="center" width="65">@%db:precio%@</td>
 <td class="texto" align="center" width="108">
<input type="text" name="array_numero[@%db:idx_detalle;%@]" value="@%db:cantidad;%@" class="insertext" size="5">
</td>
 </tr>
 <tr>
<td height="10"></td>
</tr>
 @%end-where:%@

 </table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 @%where:nodb|nodb_order_totals;%@
 <tr> <td class="titul1" align="center" width="114">{{label_total}}:</td>
 <td class="texto" align="center"width="86"> @%db:importe%@ @%db:leyenda_divisa%@ </td>
 </tr>
 <tr> <td class="titocho" align="center" width="114">{{label_baseimponible}}:</td>
 <td class="texto" align="center" width="86"> @%db:base_imponible%@ @%db:leyenda_divisa%@</td>
 </tr>
 @%end-where:%@

 <tr> <td height="10" width="114"></td>
 </tr>
 </table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> 
<td class="accesos" align="left" colspan="3"><a href="?seccion=pda_clientes_ruta"
class="accesos">{{label_home}}</a>&nbsp;<a href="?seccion=pda_hacer_pedido&vaciar_pedido=1" class="accesos">{{acc_vaciarpedido}}</a> 
<input type="submit" name="Finalizar" value="{{acc_finalizar}}">
<!-- a href="javascript: document.forms['cesta'].submit();" class="accesos">{{acc_finalizar}}</a -->
</form>
</td>
 </tr>
<tr><td colspan="3"><br>
<form name="habituales" method="post" action="?seccion=pda_hacer_pedido">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr><td height="22" class="texto" align="right" >{{fld_refsdesde}}:</td>
 <td class="texto" align="left"><input type="text" size="14" maxlength="14" name="repo[fecha]" class="insertext"
value="dd/mm/aaaa"><input type="submit" value="{{acc_enviar}}">
 </tr>
</table>
</form>
</td></tr>
<tr>
 <td class="accesos2" align="left" colspan="3">{{label_leyenda}} :</td>
</tr>
 <tr> <td height="10" width="114"></td>
 </tr>
<tr> <td class="acceso_directo" align="center" width="27">
<input type="checkbox" name="legend[]" value="" checked>
 </td>
 <td class="texto" align="center" width="65">{{fld_nombredearticulo}}</td>
 <td class="texto" align="center" width="108">{{label_id}}</td>
 </tr>
 <tr> <td class="texto" align="center" width="27">{{fld_stock}}</td>
 <td class="texto" align="center" width="65">{{label_baseimponible}}</td>
 <td class="texto" align="center" width="108">{{fld_cantidad}}</td>
 </tr>
 <tr>
<td height="10"></td>
</tr>
</tr>
</table>
</td></tr>
</table>
</body>
</html>


