
@%plt:botonera%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Facturas.referencia" >Reference<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.fecha" >Date<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Company Name<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.referencia_externa" >Ext. Ref.<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.referencia_externa;%@" /></a></td>
<td ><a href="?_search_sort=Agentes_facturas.monto" >Amount Commission<img src="images/pixel.png" class="@%func:class_searchsort;Agentes_facturas.monto;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.base_imponible" >Taxable Income<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.monto_total" >Total Amount<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.estado" >Condition<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.estado;%@" /></a></td>
</tr>
</thead>
<!-- @%set:do=amarillo%@ @%set:ok=verde%@ -->
<tbody>
@%where:tabla|Facturas;nombre|busc;no_results|1;%@
<tr
@%if:!esta_vacio;Facturas.factura_abono;%@
 class="impropio"
@%else:%@
	@%if:!esta_vacio;num_abonos;%@
	class="resalte" 
	@%end-if:%@
@%end-if:%@
>
<td><a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@">@%db:not_empty{Facturas.referencia};%@</a></td>
<td>@%db:colocar_fecha{Facturas.fecha};%@</td>
<td>@%db:Clientes.razon_social;%@</td>
<td>@%db:Facturas.referencia_externa;%@</td>
<td>@%db:Agentes_facturas.monto;%@</td>
<td>@%db:Facturas.base_imponible;%@</td>
<td>@%db:Facturas.monto_total;%@</td>
<td class="estado" ><img src="images/pixel.png" class="@%func:switch_alfa_dec;Facturas.estado;do;ok;%@" /></td>
</tr>
 @%end-where:%@
 
</tbody>
 </table>

@%plt:botonera%@

<div class="barraoscura">Caption</div>
<table class="full"><tbody><tr>
<td class="etiqueta" >Issued</td>
<td class="estado"><img src="images/pixel.png" class="@%get:ok;%@" /></td>
<td class="etiqueta" >Not Issued</td>
<td class="estado"><img src="images/pixel.png" class="@%get:do;%@" /></td>
</tr></tbody></table>




