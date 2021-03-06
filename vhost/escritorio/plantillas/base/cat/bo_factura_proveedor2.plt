<HTML>
<HEAD>
<TITLE>INMERSA - GESTI�</TITLE>
<link rel="stylesheet" href="modulos/temas/inmersa/print/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/print/base.css" type="text/css" media="print" >
<script language="JavaScript">
function imprimirdoc() {
	printit = '@%env:printit;%@';
	if (!printit.length) return;
	if (parseInt(printit)==1) {
		window.print();
		//setTimeout('window.close()',3000);
	}
}

function recargapadre() {
	window.opener.location = window.opener.location;
}
</script>
</HEAD>
<BODY onLoad="imprimirdoc();" onUnLoad="recargapadre();">
@%set:clase_primerisima=primerapagina;%@

@%where:nodb|impresion_multiple_pedidos;%@
<div class="@%get:clase_primerisima;%@">
<!-- @%set:clase_primerisima=paginacabecera;%@ -->

<!-- paginado y nombre de empresa Tamanyo: 700-->
<div id="barra1"><div id="contadorpaginas">P�gines @%get:pagina_actual;%@ de @%get:paginas_totales;%@</div></div>

@%plt:cabecera_print%@

@%plt:cabecera_documento;%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td >Ref.</td>
 <td >Ref. Ext</td>
 <td >Article</td>
 <td >Marca</td>
 <td >Aval</td>
 <td >Quantitat</td>
 <td >Preu</td>
 <td >Desc.</td>
 <td >IVA %</td>
 <td >Import</td>
<tr>
</thead>
<tbody>
 
@%where:nodb|nodb_order_details;format_name|classDocumentDetail;%@ 

 @%if:poner_cabecera;%@
 </tbody>
</table>

<!-- Tamanyo de detalles -->
</td></tr></table>

<!-- Salto de pagina aqui y tal -->
</div><div class="pagina">

<div id="barra1"><div id="contadorpaginas">P�gines @%get:pagina_actual%@ de @%get:paginas_totales;%@</div></div>

@%plt:cabecera_documento%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado" >
<tr class="bordes" > 
 <td >Ref.</td>
 <td >Ref. Ext</td>
 <td >Article</td>
 <td >Marca</td>
 <td >Aval</td>
 <td >Quantitat</td>
 <td >Preu</td>
 <td >Desc.</td>
 <td >IVA % </td>
 <td >Import</td>
</tr>
</thead>
<tbody >
@%end-if:%@ 

<!--
@%set:id_art=id_articulo;%@
@%set:_inm_count_times=2;%@
@%if:inm_count;%@
@%set:clase_fila=resalte;%@
@%else:%@
@%unset:clase_fila;%@
@%end-if:%@
-->
<tr class="@%get:clase_fila;%@"> 
 <td >@%db:id_articulo;%@</td>
 <td >@%db:referencia_externa;%@</td>
 <!-- @%set:_chop_length=48%@ -->
 <td >@%db:do_chop{nombre};%@</td>
 <!-- @%set:_chop_length=12%@ -->
 <td >@%db:do_chop{nombre_marca};%@</td>
 <td >
@%where:tabla|Certificados;nolink|1;where|Articulos.id_articulo = $id_art;%@
 <!--@%db:Articulos.id_articulo%@-->@%db:Certificados.nombre;s|0,7;%@
@%end-where:%@

 </td>
 <td >@%db:cantidad;%@</td>
 <td >@%db:precio_articulo;%@
 @%if:!esta_vacio;leyenda_unidad_medida;%@
 / @%db:leyenda_unidad_medida;%@
 @%end-if:%@
 </td>
 <td >@%db:tipo_descuento_fmt;%@</td>
 <td >@%db:porcentaje%@</td>
 <td >@%db:base_imponible;%@</td>
</tr>

@%if:esta_vacio;es_abono;%@
<!-- @%set:reset_listados=1;%@ -->
@%where:nodb|nodb_detail_productids;nombre|productids;%@
	@%if:primera_vez;%@
	<tr class="@%get:clase_fila;%@" ><td class="productids" colspan="10" >
	@%set:hubo_productids=1;%@
	@%end-if:%@
	<div class="productid" >@%db:cantidad;%@ [@%db:lote;%@] @%db:fecha_caducidad;%@</div>
@%end-where:%@

@%if:!esta_vacio;hubo_productids;%@
@%set:hubo_productids=0;%@
</td></tr>
@%end-if:%@
@%end-if:%@

@%if:!esta_vacio;observaciones;%@
<tr class="@%get:clase_fila;%@" ><td colspan="9">@%db:observaciones;%@</td></tr> 
@%end-if:%@
@%end-where:%@ 

<!-- aqui termina el registro -->
</tbody></table>
</td></tr></table>

 @%plt:pie_print;%@

</div>
 @%end-where:%@ 

@%end-where:%@

</body>
</html>
