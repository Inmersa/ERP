<HTML>
<HEAD>
<TITLE>INMERSA - GESTIÓN</TITLE>
<link rel="stylesheet" href="modulos/temas/estilosprint.css" type="text/css">
<script language="JavaScript">
function imprimirdoc() {
printit = '@%env:printit;%@';
reloadit = '@%env:reloadit;%@';
if (!printit.length) return;
if (!reloadit.length) return;
if (parseInt(printit)==1) {
window.print();
if (parseInt(reloadit)) ReloadDown();
window.close();
}
}

function ReloadDown() {
window.opener.location = window.opener.location + '&vaciar_pedido=1';
}
</script>
</HEAD>
<BODY onLoad="imprimirdoc();" onUnLoad="ReloadDown();">
<table width="80mm" border="0" cellspacing="0" cellpadding="0">
<tr><td>
<!-- paginado y nombre de empresa-->
@%where:nodb|nodb_issuer_data;%@
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr>
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
<td colspan="1" bgcolor="#EBECED" class="titul">Empresa:</td>
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
<td width="100%" align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> <td colspan="4" class="texto" height="15">@%db:razon_social;%@ (@%db:prefijo_cif;%@@%db:cif;%@)</td>
</tr>
<tr> <td colspan="4" class="texto" height="15">@%db:direccion_facturacion;%@</td>
</tr>
<tr> <td class="texto" colspan="4" height="15">@%db:cp;%@@%db:poblacion;%@(@%db:provincia;%@)</td>
</tr>
<tr> <td class="minititulo">Telefono:</td>
 <td class="texto" height="15">@%db:telefono1;%@
 <td class="minititulo">Fax:</td>
 <td class="texto" height="15">@%db:fax;%@
</tr>
<tr>
 <td class="minititulo">Email</td>
 <td class="texto" height="15" >@%db:email;%@</td>
 <td class="minititulo">Web</td>
 <td class="texto" height="15" >@%db:web;%@</td>
</tr>
 </table>
</td>
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr>
 <tr> 
<td colspan="3" height="10"></td>
 </tr>
</table>
@%end-where:%@

@%where:nodb|nodb_reciever_data;%@
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr>
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
<td colspan="1" bgcolor="#EBECED" class="titul">Cliente:</td>
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> 
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
<td width="100%" align="center"> <table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> <td colspan="4" class="texto" height="15">@%db:razon_social;%@ @%if:esta_vacio;cif;%@
 @%else:%@
 (@%db:prefijo_cif;%@@%db:cif;%@)
 @%end-if:%@
 </td>
</tr>
<tr> <td colspan="4" class="texto" height="15">@%db:direccion_facturacion;%@</td>
</tr>
<tr> <td class="texto" colspan="4" height="15">@%db:cp;%@@%db:poblacion;%@(@%db:provincia;%@)</td>
</tr>
 </table>
</td>
<td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 <tr> 
<td colspan="3"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr>
 <tr> 
<td colspan="3" height="10"></td>
 </tr>
</table>
@%end-where:%@

@%where:nodb|nodb_order_data;%@
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="100%" height="1"></td>
 </tr> <tr><td>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td><img src="imag/p.gif" width="100%" height="1"></td>
 </tr> <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED" width="30%">Nº Ticket:</td>
 <td width="1" height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td width="72" height="15" class="texto" align="left">@%db:referencia%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Fecha:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="15"></td>
 <td height="15" class="texto" align="left">@%db:colocar_fecha{fecha};%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="15"></td>
 </tr>
</table>
 </td></tr>
 <tr> <td><img src="imag/p.gif" width="100%" height="1"></td>
 </tr> <tr>
 <td height="22" class="titocho"></td>
 </tr>
 </table>
<!-- @%set:observaciones_pedido=observaciones;%@ -->
@%end-where:%@

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr> <td colspan="9" height="1" bgcolor="#000000"></td>
</tr>
<tr> <td width="1" height="15" bgcolor="#000000"></td>
 <td class="titul" width="15%">Cant.</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul">Producto</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="10%">Pr.</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="titul" width="10%">imp.</td>
 <td width="1" bgcolor="#000000"></td>
</tr>
<tr> <td height="1" bgcolor="#000000" colspan="9"></td>
</tr>
<!-- aqui empieza el registro @%set:caracteres_linea_observaciones=130%@ -->
@%where:nodb|nodb_order_details;%@ 
<!--
@%set:id_art=id_articulo;%@
@%set:_inm_count_times=2;%@
@%if:inm_count%@
@%set:color_fondo=#DDDDDD;%@
@%else:%@
@%set:color_fondo=#FFFFFF;%@
@%end-if:%@
-->
<tr bgcolor="@%get:color_fondo;%@"> <td width="1" height="15" bgcolor="#000000"></td>
 <td class="texto" >@%db:cantidad;%@</td>
 <td width="1" bgcolor="#000000"></td>
 <!-- @%set:_chop_length=48%@ -->
 <td class="texto" >@%db:do_chop{nombre};%@</td>
 <td width="1" bgcolor="#000000"></td>
 <!-- @%set:_chop_length=12%@ -->
 <td align="center" class="texto" ><!-- @%db:precio_articulo;%@
 -->@%calc:precio_articulo + 0;round|2;output|1;%@</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="texto" align="right" ><!-- @%db:base_imponible;%@
 -->@%calc:base_imponible + 0;round|2;output|1;%@</td>
 <td width="1" bgcolor="#000000" colspan="1"></td>
</tr>
<tr> <td height="1" colspan="9" bgcolor="#000000"></td>
</tr>
@%end-where:%@ 

</td>
 </tr>
 </table>
<table width="100%" border="0" cellspacint="0" cellpadding="0">
<tr><td class="texto" height="22"></td></tr>
</table>

@%where:nodb|nodb_order_totals;%@
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="5"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr> <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED" width="40%">Total Bruto:</td>
 <td width="1" height="15" class="texto"><img src="imag/p.gif" width="1" height="100%"></td>
 <td height="15" class="texto" align="left">@%db:bruto%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">T. Descuentos:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="100%"></td>
 <td height="15" class="texto" align="left">@%db:descuentos;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">T.B. Imponible:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="100%"></td>
 <td height="15" class="texto" align="left">@%db:base_imponible%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="15"></td>
 <td align="right" class="texto" bgcolor="#EBECED">T. Impuestos:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="100%"></td>
 <td height="15" class="texto" align="left">@%db:total_impuestos%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> <td align="right" width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 <td align="right" class="texto" bgcolor="#EBECED">Importe Total:</td>
 <td height="15" class="texto"><img src="imag/p.gif" width="1" height="100%"></td>
 <td height="15" class="texto" align="left">@%db:importe%@@%db:leyenda_divisa;%@</td>
 <td width="1"><img src="imag/p.gif" width="1" height="100%"></td>
 </tr>
 <tr> <td colspan="5"><img src="imag/p.gif" width="100%" height="1"></td>
 </tr> </table>
@%end-where:%@

</td></tr>
<tr><td class="texto">Gracias por su Visita</td></tr>
</table>
</body>
</html>
