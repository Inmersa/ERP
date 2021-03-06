
<!-- 
@%set:inicio=1;%@ 
-->

@%where:tabla|Factura;nombre|busc;no_results|1;%@
	<!-- @%set:tabla_cerrada=0;%@ -->
	<!-- @%set:cambia_ruptura_forzado=0;%@ -->
	@%if:cambia_ruptura;Agentes.id_agente;st[ag_search];%@
	<!-- Cerramos la tabla abierta -->
		@%if:esta_vacio;inicio;%@
	</tbody>
	</table>
		<!-- @%set:tabla_cerrada=1;%@ -->
		@%end-if:%@
	<br>
	<table class="full" >
	<tr> 
	<td class="titulotb" >Agent:</td>
	<td >@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@ </td>
	</tr>
	</table>
	<!-- @%set:cambia_ruptura_forzado=1;%@ -->
	<!-- 
	@%set:totalizar_campo=Agentes,id_agente;%@ 
	@%set:totalizar_valor=Agentes.id_agente;%@ 
	@%set:_inm_count_times=3;%@
	@%set:_inm_count_reset=1;%@
	-->
	<table class="full">
	<tr> 
	@%where:nombre|TotalesAgente;nodb|nodb_totalizar;%@
	<td class="etiqueta">@%db:nombre_campo%@:</td>
	<td >@%db:valor_campo;%@</td>
	@%if:inm_count;%@
		</tr><tr>
	@%end-if:%@
	@%end-where:%@

	</tr>
	</table>
	@%end-if:%@

	@%if:cambia_ruptura;Clientes.id_cliente;1;%@
	<!-- Cerramos la tabla abierta por cambio de cliente -->
		@%if:esta_vacio;inicio;tabla_cerrada;%@
	</table>
		@%else:%@
			@%set:inicio=0;%@
		@%end-if:%@
	<br>
	<table class="full">
	<tr> 
	<td class="titulotb">Client:</td>
	<td colspan="3"><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.razon_social;%@</a>&nbsp;(@%db:Clientes.id_cliente;%@)&nbsp;
	@%db:Clientes.nombre;%@&nbsp;&nbsp;
	@%db:Clientes.apellidos;%@</td>
	</tr>
	<tr> 
	<td class="titulotb">NSF:</td>
	<td >@%db:Clientes.cif;%@</td>
	<td class="titulotb">Direction:</td>
	<td align="right">@%db:Clientes.direccion_facturacion;%@
	@%db:Clientes.poblacion;%@ @%db:Clientes.cp;%@ @%db:Clientes.provincia;%@
	</td>
	</table>
	<!-- 
	@%set:totalizar_campo=Clientes,id_cliente;%@ 
	@%set:totalizar_valor=Clientes.id_cliente;%@ 
	@%set:totalizar_cond_campo=Agentes,id_agente;%@ 
	@%set:totalizar_cond_valor=Agentes.id_agente;%@ 
	@%set:_inm_count_times=3;%@
	@%set:_inm_count_reset=1;%@
	-->
	<table class="full">
	<tr> 
	@%where:nombre|TotalesCliente;nodb|nodb_totalizar;%@
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
	<td ><a href="?_search_sort=Facturas.fecha" class="order" >Date<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.fecha;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.referencia" class="order" >Ref.<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.referencia;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.base_imponible" class="order" 
		>Revenu imposable<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.base_imponible;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.total_impuestos" class="order"
		>Totals Imp�t<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.total_impuestos;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.retenido" class="order">Maintenu<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.retenido;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.total_bruto" class="order"
		>Totals<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.total_bruto;%@" /></a></td>
	<td ><a href="?_search_sort=Facturas.monto_total" class="order"
		>Montant<img src="imag/pixel.png" class="@%func:class_searchsort;Facturas.monto_total;%@" /></a></td>
  	@%if:esta_vacio;st[ef_search];%@
	@%else:%@
	<td ><a href="?_search_sort=Efectos.monto" class="order" >Quantit� Totale d�Effets<img src="imag/pixel.png" class="@%func:class_searchsort;Efectos.monto;%@" /></a></td>
	<td ><a href="?_search_sort=Efectos.monto_pagado" class="order" 
		>Total pay�<img src="imag/pixel.png" class="@%func:class_searchsort;Efectos.monto_pagado;%@" /></a></td>
	@%end-if:%@
  	@%if:esta_vacio;st[ic_search];%@
	@%else:%@
	<td ><a href="?_search_sort=numero_incidencias" class="order" 
		>N� Incidences<img src="imag/pixel.png" class="@%func:class_searchsort;numero_incidencias;%@" /></a></td>
	@%end-if:%@
	</tr>
	</thead>
	<tbody class="informe" >
	@%else:%@
	<tbody class="informe" >
	@%end-if:%@

<tr
@%if:!esta_vacio;Facturas.factura_abono;%@
class="impropio"
@%end-if:%@
>
<td >@%db:Facturas.fecha;%@</td>
<td ><a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a></td>
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
