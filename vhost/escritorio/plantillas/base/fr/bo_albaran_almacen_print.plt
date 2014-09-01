<html>
<head>
<title>INMERSA - GESTIÓ</title>
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
</head>

<body onLoad="imprimirdoc();" onUnLoad="recargapadre();">
<!-- 
@%set:clase_primerisima=primerapagina;%@ 

@%if:!equals;__output__name;email;%@
	@%if:!esta_vacio;_aAppConf[print_deliverynote_ncopies];%@
		@%set:_iterate_times=_aAppConf[print_deliverynote_ncopies];%@ 
		@%set:no_mostrar_copias=0;%@ 
	@%else:%@
		@%set:_iterate_times=1;%@
		@%set:no_mostrar_copias=1;%@
	@%end-if:%@
@%else:%@
	@%set:_iterate_times=1;%@
	@%set:no_mostrar_copias=1;%@
@%end-if:%@

-->

@%where:nodb|nodb_iterate;%@
@%set:_numero_copia=iterate_num;%@

@%where:tabla|Albaranes;where| $albaranes_list;cfunc|cf_albaran_valorado;%@
<div class="@%get:clase_primerisima;%@">
<!-- @%set:clase_primerisima=paginacabecera;%@ 

@%db:Albaranes.id_albaran%@ @%db:Almacenes.id_almacen%@
@%db:Albaranes.observaciones;%@ 
@%if:!esta_vacio;Albaranes.observaciones;%@
@%set:notas=Albaranes.observaciones;%@
@%end-if:%@
@%db:Pedidos.id_empresa%@ @%db:Pedidos.id_proveedor%@ @%db:Pedidos.id_pedido;%@
@%set:id_proveedor_cabecera=Pedidos.id_proveedor%@
@%set:id_almacen_cabecera=Almacenes.id_almacen;%@
@%set:id_albaran=Albaranes.id_albaran;value|var;%@
@%db:Pedidos.id_empresa;%@ @%db:Empresas.nombre;%@ @%db:Empresas.razon_social;%@
@%set:nombre_empresa=Empresas.razon_social;value|var;%@
-->

<div id="barra1">
@%if:esta_vacio;no_mostrar_copias;%@
<div id="tipocopia" >
@%if:equals;_numero_copia;1;%@
Original
@%end-if:%@
@%if:equals;_numero_copia;2;%@
Duplicata
@%end-if:%@
@%if:equals;_numero_copia;3;%@
Triple exemplaire
@%end-if:%@
@%if:equals;_numero_copia;4;%@
Quadruplé
@%end-if:%@
@%if:equals;_numero_copia;5;%@
Quintuplé
@%end-if:%@
</div>
@%end-if:%@
<div id="contadorpaginas">Pages @%get:pagina_actual;%@ de @%get:paginas_totales;%@</div></div>

<!--
@%db:Pedidos.id_direccion%@
@%set:id_direccion=Pedidos.id_direccion%@
-->
@%plt:cabecera_print%@

<!--@%set:id_albaran_cabecera=Albaranes.id_albaran;%@-->
@%plt:cabecera_albaran%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td >Ref.</td>
 <td >EAN 13</td>
 <td >Article</td>
 <td >Marque</td>
 <td >Quant.</td>
 <td >Date limite</td>
 <td >Lot</td>
@%if:!esta_vacio;valorar_detalle_albaran;%@
 <td >Prix</td>
 <td >Rem.</td>
 <td >TVA %</td>
 <td >Montant</td>
@%end-if:%@
</tr>
</thead>
<tbody >
@%where:tabla|Detalles_albaran;contador|num_detalle;cfunc|cf_detallealbaran_valorado;not_ruta_path|Almacenes,Pedidos,Traspasos_almacen,Transportistas,Provincias,Presupuestos,Catalogo_imagenes;order|Articulos.nombre,Detalles_albaran.id_almacen_logico,Detalles_albaran.planta,Detalles_albaran.pasillo,Detalles_albaran.columna,Detalles_albaran.fila,Articulos.nombre;%@
<!-- 
@%db:Detalles_albaran.id_detalle;%@ @%db:Detalles_albaran.id_almacen_logico;%@ @%db:Articulos.id_unidad_medida;%@
@%db:Detalles_albaran.planta;%@ @%db:Detalles_albaran.pasillo;%@ @%db:Detalles_albaran.fila;%@ @%db:Detalles_albaran.columna;%@ 
-->
 @%if:poner_cabecera_albaran;%@
 </tbody>
</table>

<!-- Tamanyo de detalles -->
</td></tr></table>

</div><div class="pagina">

<div id="barra1">
@%if:esta_vacio;no_mostrar_copias;%@
<div id="tipocopia" >
@%if:equals;_numero_copia;1;%@
Original
@%end-if:%@
@%if:equals;_numero_copia;2;%@
Duplicata
@%end-if:%@
@%if:equals;_numero_copia;3;%@
Triple exemplaire
@%end-if:%@
@%if:equals;_numero_copia;4;%@
Quadruplé
@%end-if:%@
@%if:equals;_numero_copia;5;%@
Quintuplé
@%end-if:%@
</div>
@%end-if:%@
<div id="contadorpaginas">Pages @%get:pagina_actual%@ de @%get:paginas_totales;%@</div></div>

@%plt:cabecera_albaran%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td >Ref.</td>
 <td >EAN 13</td>
 <td >Article</td>
 <td >Marque</td>
 <td >Quant.</td>
 <td >Date limite</td>
 <td >Lot</td>
@%if:!esta_vacio;valorar_detalle_albaran;%@
 <td >Prix</td>
 <td >Rem.</td>
 <td >TVA %</td>
 <td >Montant</td>
@%end-if:%@
</tr>
</thead>
<tbody >
@%end-if:%@ 

<!--
@%set:_inm_count_times=2;%@
@%if:inm_count;%@
@%set:clase_fila=resalte;%@
@%else:%@
@%unset:clase_fila;%@
@%end-if:%@
-->
<tr class="bordes @%get:clase_fila;%@"> 
 <td >@%db:Articulos.id_articulo%@</td>
 <td >@%db:Articulos.codigo_barras%@</td>
 <td >@%db:Articulos.nombre;s|0,55;%@</td>
 <td >@%db:Marcas.nombre;s|0,12;%@</td>
 <td >@%db:Detalles_albaran.cantidad;%@</td>
 <td >@%db:colocar_fecha{Detalles_albaran.fecha_caducidad};%@</td>
 <td >@%db:Detalles_albaran.lote;%@</td>
@%if:!esta_vacio;valorar_detalle_albaran;%@
 <td >@%get:detalle_albaran_valorado[precio];%@</td>
 <td >@%get:detalle_albaran_valorado[descuento];%@</td>
 <td >@%get:detalle_albaran_valorado[iva];%@</td>
 <td >@%get:detalle_albaran_valorado[importe];%@</td>
@%end-if:%@
</tr>

@%if:!esta_vacio;Detalles_albaran.observaciones%@
<tr class="@%get:clase_fila;%@"><td colspan="13">@%db:Detalles_albaran.observaciones;%@</td></tr>
@%end-if:%@

@%end-where:%@ 

<!-- aqui termina el registro --> 
</tbody></table>
</td></tr></table>
 
@%if:!esta_vacio;valorar_detalle_albaran;%@
@%func:calculate_delivery_totals;%@
@%where:nodb|nodb_order_data;%@
<table class="fullstruct">
<tr><td class="left">

<table class="full">
<thead class="encabezado">
<tr>
<td >Revenu imposable</td>
<td >%</td>
<td >Taxe</td>
<td >Reteneu équivalent</td>
</tr>
</thead>
<tbody class="bordes">
 @%where:nodb|nodb_taxes_detail;%@ 
 <td >@%db:base_imponible;%@</td>
 <td >@%db:porcentaje%@ / @%db:porcentaje_recargo_equivalente;%@</td>
 <td >@%db:recargo_iva;%@</td>
 <td >@%db:recargo_equivalente;%@</td>
 </tr>
 @%end-where:%@ 

</tbody>
</table>

</td><td class="right">

<!-- Descuentos -->
<table class="full">
<thead class="encabezado">
<tr>
 <td >Brut</td>
 <td >%Rem.</td>
 <td >Montant</td>
</tr>
</thead>
<tbody class="bordes" >
 @%where:nodb|nodb_discounts_detail;%@ 
 <tr> 
 <td >@%db:base_imponible;%@</td>
 <td >@%db:nombre%@ @%db:descuento%@</td>
 <td >@%db:importe;%@</td>
 </tr>
 @%end-where:%@ 

</tbody>
</table>

</td></tr>
</table>
@%end-where:%@

@%end-if:%@

<table class="fullstruct">
<tr>
<td class="left">
	<table class="firmas">
	<tr><td class="etiqueta">Notes</td></tr>
	<tr><td >&nbsp;@%get:notas;%@</td></tr>
	</table>
</td>

<td class="middle">
@%if:!esta_vacio;valorar_detalle_albaran;%@
@%where:nodb|nodb_order_totals;%@
<table class="full">
 <tr><td class="etiqueta">Totals:</td><td >@%db:bruto%@</td></tr>
 <tr><td class="etiqueta">T. Remise:</td><td >@%db:descuentos%@</td></tr>
 <tr><td class="etiqueta">Total revenu imposable:</td><td >@%db:base_imponible%@</td></tr>
 <tr><td class="etiqueta">Totals Impôt:</td><td >@%db:total_impuestos%@</td></tr>
 <tr><td class="etiqueta">Montant:</td><td >@%db:importe%@ @%db:leyenda_divisa;%@</td></tr>
</table>
@%end-where:%@

@%end-if:%@
</td>

<td class="right" width="33%">
	<table class="firmas">
	<tr><td class="etiqueta">Client d'accord</td></tr>
	<tr><td >&nbsp;</td></tr>
	</table>
</td>
</tr>
<tr><td colspan="3" class="left" ><span class="miniletra">@%db:reemplazar_salto{Almacenes.nota_pie_albaran};%@</span></td></tr>
</table>

</div>
@%end-where:%@

@%end-where:%@

