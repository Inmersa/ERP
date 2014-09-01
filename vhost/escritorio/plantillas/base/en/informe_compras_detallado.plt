
<!-- 
@%set:inicio=1;%@ 
-->

@%where:tabla|Factura;nombre|busc;no_results|1;%@

	@%if:cambia_ruptura;Proveedores.id_proveedor;1;%@
	<!-- Cerramos la tabla abierta por cambio de cliente -->
		@%if:esta_vacio;inicio;tabla_cerrada;%@
			</tbody>
			</table>
		@%else:%@
			@%set:inicio=0;%@
		@%end-if:%@
	<br>
	<table class="full">
	<tr> 
	<td class="titulotb">Supplier:</td>
	<td colspan="3"><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.razon_social;%@</a>&nbsp;
	(@%db:Proveedores.id_proveedor;%@)&nbsp;
	@%db:Proveedores.nombre;%@&nbsp;&nbsp;
	@%db:Proveedores.apellidos;%@</td>
	</tr>
	<tr> 
	<td class="titulotb">EIN:</td>
	<td >@%db:Proveedores.cif;%@</td>
	<td class="titulotb">Address:</td>
	<td align="right">@%db:Proveedores.domicilio;%@
	@%db:Proveedores.poblacion;%@ @%db:Proveedores.cp;%@ @%db:Proveedores.provincia;%@
	</td>
	</tr>
	</table>
	<!-- 
	@%set:totalizar_campo=Proveedores,id_proveedor;%@ 
	@%set:totalizar_valor=Proveedores.id_proveedor;%@ 
	@%unset:totalizar_cond_campo;%@ 
	@%unset:totalizar_cond_valor;%@ 
	@%set:_inm_count_times=3;%@
	@%set:_inm_count_reset=1;%@
	-->
	<table class="full">
	<tr> 
	@%where:nombre|TotalesProveedor;nodb|nodb_totalizar;%@
	<td class="etiqueta">@%db:nombre_campo%@:</td>
	<td align="right">@%db:valor_campo;%@</td>
	@%if:inm_count;%@
		</tr><tr>
	@%end-if:%@
	@%end-where:%@

	</tr>
	</table>

	<br>
	<table class="full">
	<thead class="informe">
	<tr> 
	<td ><a href="?_search_sort=Facturas.fecha" class="order" >Date<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.id_factura" class="order" >ID<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.id_factura;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.referencia" class="order" >Ref.<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.base_imponible" class="order" 
		>Taxable Income<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.total_impuestos" class="order" 
		>Total Taxes<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.total_impuestos;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.retenido" class="order" >Retained<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.retenido;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.total_bruto" class="order" 
		>Gross Total<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.total_bruto;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.monto_total" class="order" 
		>Total amount<img src="images/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
  	@%if:esta_vacio;st[ef_search];%@
	@%else:%@
	<td ><a href="?_search_sort=Efectos.monto" class="order" >Total Drafts Amount<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.monto;%@" /></a></td>
	<td ><a href="?_search_sort=Efectos.monto_pagado" class="order" 
		>Total Payment<img src="images/pixel.png" class="@%func:class_searchsort;Efectos.monto_pagado;%@" /></a></td>
	@%end-if:%@
  	@%if:esta_vacio;st[ic_search];%@
	@%else:%@
	<td ><a href="?_search_sort=numero_incidencias" class="order" 
		>N� Events<img src="images/pixel.png" class="@%func:class_searchsort;numero_incidencias;%@" /></a></td>
	@%end-if:%@
	</tr>
	</thead>
	<tbody class="informe" >
	@%else:%@
	<tbody class="informe" >
	@%end-if:%@

<tr>
<td >@%db:Facturas.fecha;%@</td>
<td >@%db:Facturas.id_factura;%@</td>
<td >@%db:Facturas.referencia;%@</td>
<td class="importe">@%db:Facturas.base_imponible;%@</td>
<td class="importe">@%db:Facturas.total_impuestos;%@</td>
<td class="importe">@%db:Facturas.retenido;%@</td>
<td class="importe">@%db:Facturas.total_bruto;%@</td>
<td class="importe">@%db:Facturas.monto_total;%@</td>
@%if:esta_vacio;st[ef_search];%@
@%else:%@
<td class="importe">@%db:Efectos.monto;%@</td>
<td class="importe">@%db:Efectos.monto_pagado;%@</td>
@%end-if:%@
@%if:esta_vacio;st[ic_search];%@
@%else:%@
<td >@%db:numero_incidencias;%@</td>
@%end-if:%@
</tr>
@%end-where:%@

</tbody>
</table>
