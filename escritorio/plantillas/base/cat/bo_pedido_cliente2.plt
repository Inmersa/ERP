<HTML>
<HEAD>
<TITLE>INMERSA - GESTI�</TITLE>
<link rel="stylesheet" href="modulos/temas/estilosprint.css" type="text/css">
<script language="JavaScript">
function imprimirdoc() {
printit = '@%env:printit;%@';
if (!printit.length) return;
if (parseInt(printit)==1) {
window.print();
// window.close();
}
}
</script>
</HEAD>
<BODY offonLoad="imprimirdoc();">

@%where:nodb|impresion_multiple_pedidos;%@
<!-- paginado y nombre de empresa-->
@%if:primera_vez;%@
@%else:%@
<table class="SaltoDePagina">
<tr><td height="0"></td></tr>
</table>
@%end-if:%@
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td class="titocho">@%get:nombre_empresa;%@</td>
<td class="texto" align="right">P�gines @%func:poner_num_p%@ de @%func:poner_tot_p%@</td>
 </tr>
 <tr> 
<td class="titocho" height="5" colspan="2"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr> 
<td class="titocho" height="5" colspan="2"></td>
 </tr>
</table>
@%plt:cabecera_print%@
@%plt:cabecera_pedido%@
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr>
<td height="570" valign="top"> 

<!--titulos de listados de detalles-->

 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td height="1" bgcolor="#000000"></td>
</tr>
 </table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td width="1" height="15" bgcolor="#000000"></td>
 <td class="titul" width="32">Ref.</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="50">Preu Rec.</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul">Article</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="75">Marca</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="titul" width="55">Aval</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="titul" width="30">Quantitat</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="50">Preu</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="30">Desc.</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="30">IVA<span class="texto">%</span></td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="titul" width="55">Import</td>
 <td width="1" bgcolor="#000000"></td>
</tr>
 </table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td height="1" bgcolor="#000000"></td>
</tr>
 </table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
 
<!-- aqui empieza el registro @%set:caracteres_linea_observaciones=130%@ -->

@%where:nodb|nodb_order_details;%@ 
<!-- 
@%db:medir_observaciones{observaciones};%@
 -->

 @%if:poner_cabecera%@
 </td>
 </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" class="SaltoDePagina">
 <tr>
<td></td>
 </tr>
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td class="titocho">@%get:nombre_empresa;%@</td>
<td class="texto" align="right">P�gines @%func:poner_num_p%@ de @%func:poner_tot_p%@</td>
 </tr>
 <tr> 
<td class="titocho" height="5" colspan="2"><img src="imag/p.gif" width="700" height="1"></td>
 </tr>
 <tr> 
<td class="titocho" height="5" colspan="2"></td>
 </tr>
</table>
@%plt:cabecera_print%@
@%plt:cabecera_pedido%@

<table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr>
<td height="560" valign="top"> 
<!--titulos de listados de detalles-->
 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td height="1" bgcolor="#000000"></td>
</tr>
 </table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td width="1" height="15" bgcolor="#000000"></td>
 <td class="titul" width="32">Ref.</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="50">Preu Rec.</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" width="43">Article</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="75">Marca</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="titul" width="55">Aval</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="titul" width="30">Quantitat</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="50">Preu</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="30">Desc.</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="titul" align="center" width="30">IVA<span class="texto">%</span></td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="titul" width="55">Import</td>
 <td width="1" bgcolor="#000000"></td>
</tr>
 </table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td height="1" bgcolor="#000000"></td>
</tr>
 </table>
 
<table width="700" border="0" cellspacing="0" cellpadding="0">
@%else:%@ 
@%end-if:%@ 

<!--
@%set:id_art=id_articulo;%@
@%set:_inm_count_times=2;%@
@%if:inm_count;%@
@%set:color_fondo=#DDDDDD;%@
@%else:%@
@%set:color_fondo=#FFFFFF;%@
@%end-if:%@
-->
<tr bgcolor="@%get:color_fondo;%@"> <td width="1" height="15" bgcolor="#000000"></td>
 <td class="texto" width="32">@%db:id_articulo;%@</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="texto" width="50" >@%db:PVP_rec;%@</td>
 <td width="1" bgcolor="#000000"></td>
 <!-- @%set:_chop_length=43%@ -->
 <td class="texto" width="43" >@%db:do_chop{nombre};%@</td>
 <td width="1" bgcolor="#000000"></td>
 <!-- @%set:_chop_length=12%@ -->
 <td class="texto" width="75" align="center">@%db:do_chop{nombre_marca};%@</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="texto" align="center" width="55" >
@%where:tabla|Certificados;nolink|1;where|Articulos.id_articulo = $id_art;%@
 <!--@%db:Articulos.id_articulo%@-->@%db:Certificados.nombre;s|0,7;%@
@%end-where:%@

 </td>
 <td width="1" bgcolor="#000000"></td>
 <td class="texto" align="center" width="30" >@%db:cantidad;%@</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="texto" width="50" >@%db:precio_articulo;%@</td>
 <td width="1" bgcolor="#000000"></td>
 <td align="center" class="texto" width="30" >@%db:descuento;%@</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="texto" align="center" width="30" >@%db:porcentaje%@</td>
 <td width="1" bgcolor="#000000"></td>
 <td class="texto" align="right" width="55" >@%db:base_imponible;%@</td>
 <td width="1" bgcolor="#000000"></td>
</tr>
<tr> <td height="1" colspan="21" bgcolor="#000000"></td>
</tr>

@%if:hay_comentario%@
</table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
<tr>
 <td width="1" height="15" bgcolor="#000000"></td>
 <td align="left" class="texto" bgcolor="@%get:color_fondo;%@">
 @%db:reemplazar_salto{observaciones};%@</td>
 <td width="1" height="15" bgcolor="#000000"></td>
</tr>
</table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
<tr> <td height="1" bgcolor="#000000"></td>
</tr>
 </table>
<table width="700" border="0" cellspacing="0" cellpadding="0">
@%else:%@
@%end-if:%@
@%end-where:%@ 

<!-- aqui termina el registro -->
 </table>
 
</td>
 </tr>
 </table>
 @%plt:pie_print%@
 @%end-where:%@ 
@%end-where:%@

</body>
</html>
