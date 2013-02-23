@%where:nombre|factura_print_standard;import_data|1;%@
@%func:page_std_invoice;%@
<div class="@%get:clase_primerisima;%@">
<!-- @%set:clase_primerisima=paginacabecera;%@ -->
<div id="barra1">
@%if:!esta_vacio;_numero_copia;%@
<div id="tipocopia" >
@%if:equals;_numero_copia;1;%@
Original
@%end-if:%@
@%if:equals;_numero_copia;2;%@
Duplicate
@%end-if:%@
@%if:equals;_numero_copia;3;%@
Trebled
@%end-if:%@
@%if:equals;_numero_copia;4;%@
Quadruplicated
@%end-if:%@
@%if:equals;_numero_copia;5;%@
Fifth Copy
@%end-if:%@
</div>
@%end-if:%@
<div id="contadorpaginas">Page @%get:pagina_actual;%@ of @%get:paginas_totales;%@</div></div>

@%if:!esta_vacio;factura_abono;%@
@%set:es_abono=1;%@
@%end-if:%@

@%plt:cabecera_print%@

@%plt:cabecera_documento;%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado">
<tr class="bordes">
 <td class="@%css:id_articulo;label;%@" >Ref.</td>
 <td class="@%css:PVP_rec;label;%@" >Recomm. Price</td>
 <td >Product</td>
@%if:!esta_vacio;_aAppConf[print_observaciones_enlinea];%@
 <td > </td>
@%end-if:%@
 <td class="@%css:nombre_marca;label;%@" >Brand</td>
 <td class="@%css:certificado;label;%@" >Guarantee</td>
 <td >Amount</td>
 <td >Price</td>
 <td class="@%css:descuento;label;%@" >Discount</td>
 <td >VAT %</td>
 <td >Amount</td>
<tr>
</thead>
<tbody>
@%where:nodb|nodb_order_details;nombre|detalles;format_name|classDocumentDetail;%@ 

 @%if:poner_cabecera;%@
 </tbody>
</table>
<!-- Tamanyo de detalles -->
</td></tr></table>

<!-- Salto de pagina aqui y tal -->
</div><div class="pagina">

<div id="barra1">
@%if:!esta_vacio;_numero_copia;%@
<div id="tipocopia" >
@%if:equals;_numero_copia;1;%@
Original
@%end-if:%@
@%if:equals;_numero_copia;2;%@
Duplicate
@%end-if:%@
@%if:equals;_numero_copia;3;%@
Trebled
@%end-if:%@
@%if:equals;_numero_copia;4;%@
Quadruplicated
@%end-if:%@
@%if:equals;_numero_copia;5;%@
Fifth Copy
@%end-if:%@
</div>
@%end-if:%@
<div id="contadorpaginas" >Page @%get:pagina_actual%@ of @%get:paginas_totales;%@</div></div>

@%plt:cabecera_documento%@

<table class="lineasdetalle"><tr><td class="lineasdetalle" >

<table class="full">
<thead class="encabezado" >
<tr class="bordes" > 
 <td class="@%css:id_articulo;label;%@" >Ref.</td>
 <td class="@%css:PVP_rec;label;%@" >Recomm. Price</td>
 <td >Product</td>
@%if:!esta_vacio;_aAppConf[print_observaciones_enlinea];%@
 <td > </td>
@%end-if:%@
 <td class="@%css:nombre_marca;label;%@" >Brand</td>
 <td class="@%css:certificado;label;%@" >Guarantee</td>
 <td >Amount</td>
 <td >Price</td>
 <td class="@%db:css:descuento;label;%@" >Discount</td>
 <td >VAT % </td>
 <td >Amount</td>
</tr>
</thead>
<tbody >
@%else:%@ 
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
 <td class="@%css:id_articulo;%@" >@%db:id_articulo;%@</td>
 <td class="@%css:PVP_rec;%@" >@%db:PVP_rec;%@</td>
 <!-- @%set:_chop_length=48%@ -->
 <td >@%db:do_chop{nombre};%@</td>
@%if:!esta_vacio;_aAppConf[print_observaciones_enlinea];%@
 <td >@%db:observaciones;%@</td>
@%end-if:%@
 <!-- @%set:_chop_length=12%@ -->
 <td class="@%css:nombre_marca;%@" >@%db:do_chop{nombre_marca};%@</td>
 <td class="@%css:certificado;%@" >@%db:certificado;%@</td>
 <td >@%db:cantidad;%@</td>
 <td >@%db:precio_articulo;%@
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>
 <td class="@%css:descuento;%@" >@%db:tipo_descuento_fmt;%@</td>
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
	@%if:!esta_vacio;cantidad;%@
	<div class="productid" >@%db:lcredec{cantidad};%@ 
		@%if:!esta_vacio;lote;%@
		[@%db:lote;%@] 
		@%end-if:%@
		@%db:colocar_fecha{fecha_caducidad};%@
	</div>
	@%end-if:%@
@%end-where:%@

@%end-if:%@
@%if:!esta_vacio;hubo_productids;%@
@%set:hubo_productids=0;%@
</td></tr>
@%end-if:%@

@%if:esta_vacio;_aAppConf[print_observaciones_enlinea];%@
@%if:!esta_vacio;observaciones;%@
<tr class="@%get:clase_fila;%@" ><td colspan="10">@%db:observaciones;%@</td></tr> 
@%end-if:%@
@%end-if:%@

@%end-where:%@ 

<!-- aqui termina el registro -->
</tbody>
 </table>
</td></tr></table>
 
 @%plt:pie_print%@

</div>
 @%end-where:%@ 

@%end-where:%@

</body>
</html>
