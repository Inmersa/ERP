
@%plt:botonera%@

<table class="full">

<thead>
<tr>
<td ><a href="?_search_sort=Facturas.referencia" >Ref.<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
<td ><a href="?_search_sort=Clientes.razon_social" >Client<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.fecha" >Date<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.base_imponible" >Taxable Income<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.total_impuestos" >Taxes<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.total_impuestos;%@" /></a></td>
<td ><a href="?_search_sort=Facturas.monto_total" >Total<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
<td >Condition</td>
</tr>
</thead>
<!-- @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ -->
<tbody>
@%where:tabla|Facturas;nombre|busc;no_results|1;order|Facturas.fecha desc, Facturas.referencia desc;%@ 
<!-- @%db:Facturas.referencia_externa;%@ @%db:Facturas.notas;%@ @%db:Facturas.monto_cuenta;%@ 
@%db:Facturas.retenido;%@ @%db:Facturas.descuento;%@  @%db:Facturas.estado;%@ -->
<tr>
<td><a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@"
>@%db:not_empty{Facturas.referencia};%@</a></td>
<td>@%db:Clientes.razon_social;%@</td>
<td>@%db:colocar_fecha{Facturas.fecha};%@</td>
<td>@%db:Facturas.base_imponible;%@</td>
<td>@%db:Facturas.total_impuestos;%@</td>
<td>@%db:Facturas.monto_total;%@</td>
<td align="center"><img src="imag/@%func:switch_alfa_dec;Facturas.estado;do;ok;%@" /></td>
</tr>
 @%end-where:%@

</tbody>
 </table>

@%plt:botonera%@

<div class="barraoscura">Caption</div>
<table class="full">
<td class="etiqueta" >Issued</td>
<td align="left"><img src="imag/@%get:ok;%@" width="14" height="14" /></td>
<td class="etiqueta" >Not Issued</td>
<td align="left"><img src="imag/@%get:do;%@" width="14" height="14" /></td>
</tr>
</table>




