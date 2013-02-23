
@%plt:botonera%@

<!-- @%unset:grafica;%@ @%unset:leyenda;%@ -->
<table class="full">
<thead><tr>
<td ><a href="?_search_sort=Clientes.razon_social" >Nombre cliente<img src="images/pixel.png" class="@%func:class_searchsort;Clientes.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=num_facturas" >Facturas<img src="images/pixel.png" class="@%func:class_searchsort;num_facturas;%@" /></a></td>
<td ><a href="?_search_sort=total_facturas" >Facturado<img src="images/pixel.png" class="@%func:class_searchsort;total_facturas;%@" /></a></td>
<td ><a href="?_search_sort=comision" >Importe Comisi�n<img src="images/pixel.png" class="@%func:class_searchsort;comision;%@" /></a></td>
<td ><a href="?_search_sort=comision_media" >Comisiones<img src="images/pixel.png" class="@%func:class_searchsort;comision_media;%@" /></a></td>
<td ><a href="?_search_sort=monto_pagado" >Cobrado<img src="images/pixel.png" class="@%func:class_searchsort;monto_pagado;%@" /></a></td>
</tr></thead>

<tbody>
@%where:tabla|Agentes_facturas;no_results|1;group|Clientes.id_cliente;nombre|busc;cfunc|valores_grafica;%@
<!-- @%db:Agentes_facturas.id_agente%@ 
@%calc:total_facturado = total_facturado + total_facturas%@
@%calc:total_comisiones = total_comisiones + comision%@
@%calc:total_cobrado = total_cobrado + monto_pagado%@ 
@%calc:total_fras = total_fras + num_facturas;%@
@%calc:num_clientes = num_clientes + 1;%@
-->
<tr>
<td> @%db:Clientes.razon_social;%@ (@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@)</td>
<td>@%db:num_facturas;%@</td>
<td>@%db:total_facturas;%@</td>
<td>@%calc:comision+0;output|1;round|2;%@</td>
<td>@%calc:comision_media+0;output|1;round|2;%@ %</td>
<td>@%db:monto_pagado;%@</td>
</tr>
@%end-where:%@

</tbody>
</table>

<table class="full">
<thead><tr>
<td >N� Clientes</td>
<td >Facturas</td>
<td >Facturado</td>
<td >Comisiones</td>
<td >Cobrado</td>
</tr></thead>
<tbody><tr>
<td>@%get:num_clientes%@</td>
<td>@%get:total_fras%@</td>

<td>@%get:total_facturado%@</td>
<td>@%get:total_comisiones%@</td>
<td>@%get:total_cobrado%@</td>
</tbody></table>

@%plt:botonera;%@

<!-- 
@%set:grafica[titulo] = Informe de Ventas: Agente por Cliente;%@
@%set:grafica[charts] = facturado cobrado comisiones;%@
@%set:grafica[limit] = 5;%@

@%set:facturado[titulo] = Facturado;%@
@%set:cobrado[titulo] = Cobrado;%@
@%set:comisiones[titulo] = Comisiones;%@
-->
@%plt:grafica;%@


