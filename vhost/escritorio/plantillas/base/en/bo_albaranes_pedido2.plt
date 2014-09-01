<html>
<head>
<title>INMERSA - MANAGEMENT</title>
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

<body OFFonLoad="imprimirdoc();" onUnLoad="recargapadre();">
<!-- @%set:clase_primerisima=primerapagina;%@ -->

@%where:tabla|Albaranes;where|Albaranes.id_pedido = $id_pedido;cfunc|cf_calcular_paginado;%@
<div class="@%get:clase_primerisima;%@">
<!-- @%set:clase_primerisima=paginacabecera;%@ 
@%db:Albaranes.id_albaran%@
@%db:Almacenes.id_almacen%@
@%db:Pedidos.id_empresa%@ @%db:Pedidos.id_proveedor%@
@%set:id_proveedor_cabecera=Pedidos.id_proveedor%@
@%set:id_almacen_cabecera=Almacenes.id_almacen;%@
@%db:Pedidos.id_empresa%@
@%db:Empresas.nombre%@
@%db:Empresas.razon_social%@
@%set:nombre_empresa=Empresas.razon_social;%@
-->

<div id="barra1"><div id="contadorpaginas">Page @%get:pagina_actual;%@ of @%get:paginas_totales;%@</div></div>

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
 <td rowspan="2" >Ref.</td>
 <td rowspan="2" >EAN 13</td>
 <td rowspan="2" >Product</td>
 <td rowspan="2" >Brand</td>
 <td rowspan="2" >Uts Ord</td>
 <td rowspan="2" >Uts Serv</td>
 <td rowspan="2" >Pkgs</td>
 <td rowspan="2" >&nbsp;</td>
 <td colspan="4" >Location</td>
 <td rowspan="2" >By Date</td>
</tr>
<tr class="bordes">
 <td>Floor</td>
 <td>Corr</td>
 <td>Col</td>
 <td>Row</td>
</tr>
</thead>
<tbody>

<!-- aqui empieza el registro -->

@%where:tabla|Detalles_albaran;not_ruta_path|Almacenes,Pedidos,Traspasos_almacen,Transportistas,Provincias,Presupuestos,Catalogo_imagenes;order|Articulos.nombre,Detalles_albaran.id_almacen_logico,Detalles_albaran.planta,Detalles_albaran.pasillo,Detalles_albaran.columna,Detalles_albaran.fila,Articulos.nombre;contador|num_detalle;%@
<!-- @%db:Detalles_albaran.id_detalle;%@ @%db:Articulos.id_unidad_medida;%@ -->
 @%if:poner_cabecera_albaran;%@
 </tbody>
</table>

<!-- Tamanyo de detalles -->
</td></tr></table>

</div><div class="pagina">

<div id="barra1"><div id="contadorpaginas">Page @%get:pagina_actual%@ of @%get:paginas_totales;%@</div></div>

@%plt:cabecera_albaran%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td rowspan="2" >Ref.</td>
 <td rowspan="2" >EAN 13</td>
 <td rowspan="2" >Product</td>
 <td rowspan="2" >Brand</td>
 <td rowspan="2" >Uts Ord</td>
 <td rowspan="2" >Uts Serv</td>
 <td rowspan="2" >Pkgs</td>
 <td rowspan="2" >&nbsp;</td>
 <td colspan="4" >Location</td>
 <td rowspan="2" >By Date</td>
</tr>
<tr class="bordes">
 <td>Floor</td>
 <td>Corr</td>
 <td>Col</td>
 <td>Row</td>
</tr>
</thead>
<tbody>

@%else:%@ 
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
 <td align="center" >@%db:Certificados.nombre%@</td>
 <td >@%db:Articulos.nombre;s|0,50;%@</td>
 <td >@%db:Marcas.nombre;s|0,12;%@</td>
 <td >@%db:Lineas_detalle.cantidad;%@</td>
 <td >@%db:Detalles_albaran.cantidad;%@</td>
 <td >
   <!-- @%set:cant=Detalles_albaran.cantidad;%@ @%set:udsb=Empresas_articulos.unidades_bulto;%@ @%db:Empresas_articulos.unidades_bulto;%@ -->
   @%if:esta_vacio;udsb;%@
   @%else:%@
   @%calc:cant / udsb;round|3;output|1;%@
   @%end-if:%@
 </td>
 <td ><input type="checkbox" class="insertext" ></td>
 <td>@%db:Detalles_albaran.planta%@</td>
 <td>@%db:Detalles_albaran.pasillo%@</td>
 <td>@%db:Detalles_albaran.columna%@</td>
 <td>@%db:Detalles_albaran.fila%@</td>
 <td>@%db:colocar_fecha{Detalles_albaran.fecha_caducidad}_%@</td>
 </tr>
@%if:!esta_vacio;Detalles_albaran.observaciones;%@
<tr class="@%get:clase_fila;%@"><td colspan="12">@%db:Detalles_albaran.observaciones;%@</td></tr>
@%end-if:%@

@%end-where:%@ 

<!-- aqui termina el registro --> 
</tbody></table>
</td></tr></table>

@%if:!esta_vacio;Albaranes.observaciones;%@
<table class="full"><thead class="encabezado"><tr class="bordes" ><td >Notes</td></tr></thead>
<tbody><tr><td >&nbsp;@%db:reemplazar_salto{Albaranes.observaciones};%@</td></tr></tbody></table>
@%end-if:%@

<table class="firmas">
 <tr >
   <td class="etiqueta" >Signed</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
 </tr>
 <tr >
   <td class="etiqueta">Stages</td>
   <td class="etiqueta">Prepared by</td>
   <td class="etiqueta">Packed by</td>
   <td class="etiqueta">Verified by</td>
   <td class="etiqueta">Billed by</td>
   <td class="etiqueta">Sended</td>
 </tr>
 <tr>
   <td class="etiqueta" >Dated in</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
 </tr>
</table>

</div>
 @%end-where:%@ 

</body>
</html>
