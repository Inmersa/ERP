
 @%plt:botonera%@ 

 <table class="full">
 <thead>
 <tr>
 <td ><a href="?_search_sort=Facturas.referencia" >R�f�rence<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
 <td ><a href="?_search_sort=Facturas.fecha" >Date<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
 <td ><a href="?_search_sort=Facturas.referencia_externa" >R�f. Ext<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia_externa;%@" /></a></td>
 <td ><a href="?_search_sort=Forma_pago.nombre" >Modes de paiement<img src="imag/pixel.png" class="@%func:class_searchsort;Forma_pago.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Tarifas.nombre" >Tarif<img src="imag/pixel.png" class="@%func:class_searchsort;Tarifas.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Facturas.base_imponible" >Revenu imposable<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" /></a></td>
 <td ><a href="?_search_sort=Facturas.monto_total" >Totals<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
 <td >E</td>
 </tr>
 </thead>
<!-- @%set:do=cuadrado.png%@ @%set:ok=circulo.png%@ -->
 @%where:tabla|Facturas;nombre|busc;no_results|1;order|Facturas.fecha desc;%@ <tr>
 <td>
 @%if:AllowedLink;bo_factura_cliente;%@
 <a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" >@%db:not_empty{Facturas.referencia};%@</a>
 @%else:%@
 @%db:not_empty{Facturas.referencia};%@
 @%end-if:%@
 </td>
 <td>@%db:colocar_fecha{Facturas.fecha};%@</td>
 <td>@%db:Facturas.referencia_externa;%@</td>
 <td>@%db:Forma_pago.nombre;%@</td>
 <td>@%db:Tarifas.nombre;s|0,18;%@</td>
 <td>@%db:Facturas.base_imponible;%@</td>
 <td>@%db:Facturas.monto_total;%@</td>
 <td><img src="imag/@%func:switch_alfa_dec;Facturas.estado;do;ok;%@" /></td>
 </tr>
 <!-- @%calc: total_pagina = total_pagina + Facturas.monto_total;round|2;%@ -->
 @%end-where:%@ 

 </table>

@%plt:botonera%@

<div class="barraoscura">L�gende</div>
<table class="full">
<td class="etiqueta" >�mis</td>
<td align="left" ><img src="imag/@%get:ok;%@" width="14" height="14" /></td>
<td class="etiqueta" >Sans �mettre</td>
<td align="left"><img src="imag/@%get:do;%@" width="14" height="14" /></td>
</tr>
</table>

