<html>
<head>
<title>INMERSA - GESTI�</title>
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
<!-- @%set:clase_primerisima=primerapagina;%@ -->
@%where:tabla|Albaranes;where| $albaranes_list;cfunc|cf_calcular_paginado;%@
<div class="@%get:clase_primerisima;%@">
<!-- @%set:clase_primerisima=paginacabecera;%@ 
@%db:Albaranes.id_albaran%@ @%db:Albaranes.referencia%@ @%db:Almacenes.id_almacen%@ @%db:Pedidos.id_empresa%@ @%db:Pedidos.id_proveedor%@
@%db:Empresas.nombre%@ @%db:Pedidos.id_direccion%@ @%db:Empresas.razon_social;%@

@%set:id_albaran=Albaranes.id_albaran;value|var;%@
@%set:id_almacen_cabecera=Almacenes.id_almacen;%@
@%set:id_proveedor_cabecera=Pedidos.id_proveedor%@
@%set:id_direccion=Pedidos.id_direccion%@
@%set:nombre_empresa=Empresas.razon_social;%@
-->

<div id="barra1"><div id="contadorpaginas">Pages @%get:pagina_actual%@ de @%get:paginas_totales;%@</div></div>

@%plt:cabecera_print%@

<!--@%set:id_albaran_cabecera=Albaranes.id_albaran;%@-->
@%plt:cabecera_albaran%@
 
<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td rowspan="2" >Ref.</td>
 <td rowspan="2" >EAN 13</td>
 <td rowspan="2" >Article</td>
 <td rowspan="2" >Marque</td>
 <td rowspan="2" >Qt. Dem</td>
 <td rowspan="2" >Qt. Rem</td>
 <td rowspan="2" >Bosses</td>
 <td rowspan="2" >&nbsp;</td>
 <td colspan="4" >Localisation</td>
 <td rowspan="2" >Dt. Lim</td>
</tr>
<tr class="bordes">
 <td>Pl</td>
 <td>Cou</td>
 <td>Col</td>
 <td>Rang</td>
</tr>
</thead>
<tbody >

@%where:tabla|Detalles_albaran;not_ruta_path|Almacenes,Pedidos,Traspasos_almacen,Transportistas,Provincias,Presupuestos,Catalogo_imagenes;order|Detalles_albaran.id_almacen_logico,Detalles_albaran.planta,Detalles_albaran.pasillo,Detalles_albaran.columna,Detalles_albaran.fila,Articulos.nombre;contador|num_detalle;%@ 
<!-- @%db:Detalles_albaran.id_detalle;%@ @%db:Detalles_albaran.id_almacen_logico;%@ @%db:Articulos.id_unidad_medida;%@ -->
@%if:poner_cabecera_albaran;%@
 </tbody>
</table>

<!-- Tamanyo de detalles -->
</td></tr></table>

</div><div class="pagina">

<div id="barra1"><div id="contadorpaginas">Pages @%get:pagina_actual%@ de @%get:paginas_totales;%@</div></div>

@%plt:cabecera_albaran;%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td rowspan="2" >Ref.</td>
 <td rowspan="2" >EAN 13</td>
 <td rowspan="2" >Article</td>
 <td rowspan="2" >Marque</td>

 <td rowspan="2" >Qt. Dem</td>
 <td rowspan="2" >Qt. Rem</td>
 <td rowspan="2" >Bosses</td>

 <td rowspan="2" >&nbsp;</td>
 <td colspan="4" >Localisation</td>
 <td rowspan="2" >Date limite</td>
</tr>
<tr class="bordes">
 <td>Pl</td>
 <td>Cou</td>
 <td>Col</td>
 <td>Rang</td>
</tr>
</thead>
<tbody>
@%end-if:%@ 

<!--
@%set:_inm_count_times=2;%@
@%if:inm_count;%@
@%set:color_fondo=#DDDDDD;%@
@%else:%@
@%set:color_fondo=#FFFFFF;%@
@%end-if:%@
-->
 <tr bgcolor="@%get:color_fondo;%@"> 
 <td >@%db:Articulos.id_articulo%@</td>
 <td >@%db:Articulos.codigo_barras;%@</td>
 <td >@%db:Articulos.nombre;s|0,43;%@</td>
 <td >@%db:Marcas.nombre;s|0,12;%@</td>
 <td >@%db:Lineas_detalle.cantidad;%@</td>
 <td >@%db:Detalles_albaran.stock_previsto;%@</td>
 <td >
   <!-- @%set:cant=Detalles_albaran.stock_previsto;%@ @%set:udsb=Empresas_articulos.unidades_bulto;%@ @%db:Empresas_articulos.unidades_bulto;%@ -->
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
 <td>@%db:colocar_fecha{Detalles_albaran.fecha_caducidad};%@ 
 @%if:!esta_vacio;Detalles_albaran.lote;%@
 (@%db:Detalles_albaran.lote;%@)
 @%end-if:%@
 </td>
</tr>

@%if:!esta_vacio;Detalles_albaran.observaciones;%@
<tr bgcolor="@%get:color_fondo;%@">
<td colspan="12">@%db:Detalles_albaran.observaciones;%@</td>
</tr>
@%end-if:%@

@%end-where:%@ 

<!-- aqui termina el registro --> 
</tbody></table>
</td></tr></table>

@%if:!esta_vacio;Albaranes.observaciones;%@
<table class="full"><thead class="encabezado"><tr class="bordes" ><td >Notes</td></tr></thead>
<tbody><tr><td >&nbsp;@%db:reemplazar_salto{Albaranes.observaciones};%@</td></tr></tbody></table>
@%end-if:%@

<table class="fullstruct"><tr><td>
<table class="firmas">
 <tr >
   <td class="etiqueta" >Sign�</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
 </tr>
 <tr >
   <td class="etiqueta">�tapes</td>
   <td class="etiqueta">Pr�paration par</td>
   <td class="etiqueta">Empaquetage par</td>
   <td class="etiqueta">V�rifi� par</td>
   <td class="etiqueta">Factur� par</td>
   <td class="etiqueta">Envoy�</td>
 </tr>
 <tr>
   <td class="etiqueta" >Dat� dans</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
   <td > &nbsp;</td>
 </tr>
</table>
</td></tr></table>
</div>
 @%end-where:%@
 
</body>
</html>

