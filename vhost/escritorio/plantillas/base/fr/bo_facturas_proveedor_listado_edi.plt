
@%plt:botonera%@

<table class="full">
<thead><tr>
<td ><a href="?_search_sort=Facturas.referencia" class="order" >Ref.<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.fecha" class="order" >Date<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.referencia_externa" class="order" 
	>R�f. Ext<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia_externa;%@" /></a></td>
<td ><a href="?_search_sort=Forma_pago.nombre" class="order" >Modes de paiement<img src="imag/pixel.png" class="@%func:class_searchsort;Forma_pago.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.monto_total" class="order" >Totals<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.estado" class="order" >�tat<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.estado;%@" /></a></td>
</tr></thead>
<tbody>
<!-- @%set:do=amarillo%@ @%set:ok=verde%@ -->
@%where:tabla|Facturas;nombre|busc;no_results|1;order|Facturas.fecha desc;%@
<tr
@%if:!esta_vacio;Facturas.factura_abono;%@
 class="impropio"
@%else:%@
	@%if:!esta_vacio;num_abonos;%@
	class="resalte" 
	@%end-if:%@
@%end-if:%@
>
<td><a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@">@%db:not_empty{Facturas.referencia};%@</a></td>
<td>@%db:colocar_fecha{Facturas.fecha};%@</td>
<td>@%db:Facturas.referencia_externa;%@</td>
<td>@%db:Forma_pago.nombre;%@</td>
<td>@%db:Facturas.monto_total;%@</td>
<td class="estado" ><img src="imag/pixel.png" class="@%func:switch_alfa_dec;Facturas.estado;do;ok;%@" /></td>
</tr>
@%end-where:%@

</tbody></table>
@%plt:botonera%@ 

<div class="barraoscura">L�gende</div>
<table class="full"><tbody><tr>
<td class="etiqueta" >�mis</td>
<td class="estado" ><img src="imag/pixel.png" class="@%get:ok;%@" /></td>
<td class="etiqueta" >Sans �mettre</td>
<td class="estado" ><img src="imag/pixel.png" class="@%get:do;%@" /></td>
</tr></tbody></table>



