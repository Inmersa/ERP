<HTML>
<HEAD>
<TITLE>INMERSA - GESTIÓN</TITLE>
<link rel="stylesheet" href="modulos/temas/estilosprint.css" type="text/css">
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

<div id="contenido">
@%where:nodb|impresion_multiple_pedidos;%@
<!-- paginado y nombre de empresa Tamanyo: 700-->
<div id="barra1"><div id="logo">@%get:nombre_empresa;%@</div><div id="contadorpaginas">Pag @%func:poner_num_p%@ de @%func:poner_tot_p%@</div></div>

@%plt:cabecera_print%@

@%plt:cabecera_documento;%@

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td >Ref.</td>
 <td >Ref. Ext.</td>
 <td >Producto</td>
 <td >Marca</td>
 <td >Cert.</td>
 <td >Cant.</td>
 <td >Precio</td>
 <td >Dto</td>
 <td >IVA %</td>
 <td >Importe</td>
<tr>
</thead>
<tbody>
 
<!-- aqui empieza el registro @%set:caracteres_linea_observaciones=130%@ -->

@%where:nodb|nodb_order_details;format_name|classDocumentDetail;%@ 
<!-- 
@%db:medir_observaciones{observaciones};%@
 -->

 @%if:poner_cabecera%@
 </tbody>
</table>

<!-- Salto de pagina aqui y tal -->
</div><div id="contenido">

<div id="barra1"><div id="logo">@%get:nombre_empresa;%@</div><div id="contadorpaginas">Pag @%func:poner_num_p%@ de @%func:poner_tot_p%@</div></div>

@%plt:cabecera_print%@
@%plt:cabecera_documento%@

<table class="full">
<thead class="encabezado" >
<tr class="bordes" > 
 <td >Ref.</td>
 <td >Ref. Ext.</td>
 <td >Producto</td>
 <td >Marca</td>
 <td >Cert.</td>
 <td >Cant.</td>
 <td >Precio</td>
 <td >Dto</td>
 <td >IVA % </td>
 <td >Importe</td>
</tr>
</thead>
<tbody >
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
<tr class="bordes" bgcolor="@%get:color_fondo;%@"> 
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
 <td >@%db:precio_articulo;%@</td>
 <td >@%db:tipo_descuento_fmt;%@</td>
 <td >@%db:porcentaje%@</td>
 <td >@%db:base_imponible;%@</td>
</tr>

@%if:esta_vacio;observaciones;%@
@%else:%@
<tr bgcolor="@%get:color_fondo;%@" ><td colspan="9">@%db:observaciones;%@</td></tr> 
@%end-if:%@
@%end-where:%@ 

<!-- aqui termina el registro -->
</tbody>
 </table>
 
 @%plt:pie_print%@
 @%end-where:%@ 

@%end-where:%@

</div>
</body>
</html>
