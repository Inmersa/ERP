
<!-- 
@%set:inicio=1;%@ 
-->

@%where:tabla|Articulos;nombre|busc;no_results|1;%@
	<!-- @%set:tabla_cerrada=0;%@ -->
	<!-- @%set:cambia_ruptura_forzado=0;%@ -->
	@%if:cambia_ruptura;Marcas.id_marca;st[mc_search];%@
	<!-- Cerramos la tabla abierta (marcas)-->
		@%if:esta_vacio;inicio;%@
	</tbody>
	</table>
		<!-- @%set:tabla_cerrada=1;%@ -->
		@%end-if:%@
	<br>
	<table class="full">
	<tr> 
	<td class="titulotb" align="right">Marque:</td>
	<td >@%db:Marcas.nombre;%@ </td>
	</tr>
	</table>
	<!-- @%set:cambia_ruptura_forzado=1;%@ -->
	<!-- 
	@%set:totalizar_campo=Marcas,id_marca;%@ 
	@%set:totalizar_valor=Marcas.id_marca;%@ 
	@%set:totalizar_cond_campo=null;%@ 
	@%set:totalizar_cond_valor=null;%@ 
	@%set:_inm_count_times=3;%@
	@%set:_inm_count_reset=1;%@
	-->
	<table class="full">
	<tr> 
	@%where:nombre|TotalesMarca;nodb|nodb_totalizar;%@
	<td class="etiqueta">@%db:nombre_campo%@:</td>
	<td align="right">@%db:valor_campo;%@</td>
	@%if:inm_count;%@
		</tr><tr>
	@%end-if:%@
	@%end-where:%@

	</tr>
	</table>
	@%end-if:%@

	@%if:cambia_ruptura;Familia_articulos.id_familia;st[fm_search];%@
	<!-- Cerramos la tabla abierta (familias) -->
		@%if:esta_vacio;inicio;tabla_cerrada;%@
	</table>
		<!-- @%set:tabla_cerrada=1;%@ -->
		@%end-if:%@
	<br>
	<table class="full">
	<tr> 
	<td class="titulotb" align="right">Famille:</td>
	<td >@%db:Familia_articulos.nombre;%@ </td>
	</tr>
	</table>
	<!-- @%set:cambia_ruptura_forzado=1;%@ -->
	<!-- 
	@%set:totalizar_campo=Familia_articulos,id_familia;%@ 
	@%set:totalizar_valor=Familia_articulos.id_familia;%@ 
	@%set:totalizar_cond_campo[]=Marcas,id_marca;%@ 
	@%set:totalizar_cond_valor[]=Marcas.id_marca;%@ 
	@%set:_inm_count_times=3;%@
	@%set:_inm_count_reset=1;%@
	-->
	<table class="full">
	<tr> 
	@%where:nombre|TotalesFamilia;nodb|nodb_totalizar;%@
	<td class="etiqueta">@%db:nombre_campo%@:</td>
	<td align="right">@%db:valor_campo;%@</td>
	@%if:inm_count;%@
		</tr><tr>
	@%end-if:%@
	@%end-where:%@

	</tr>
	</table>
	@%end-if:%@

	@%if:cambia_ruptura;Agentes.id_agente;st[ag_search];%@
	<!-- Cerramos la tabla abierta (agentes) -->
		@%if:esta_vacio;inicio;tabla_cerrada;%@
	</table>
		<!-- @%set:tabla_cerrada=1;%@ -->
		@%end-if:%@
	<br>
	<table class="full">
	<tr> 
	<td class="titulotb" align="right">Agent:</td>
	<td >@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@ (@%db:Agentes.id_agente;%@)</td>
	</tr>
	</table>
	<!-- @%set:cambia_ruptura_forzado=1;%@ -->
	<!-- 
	@%set:totalizar_campo=Agentes,id_agente;%@ 
	@%set:totalizar_valor=Agentes.id_agente;%@ 
	@%set:totalizar_cond_campo[]=Familia_articulos,id_familia;%@ 
	@%set:totalizar_cond_valor[]=Familia_articulos.id_familia;%@ 
	@%set:totalizar_cond_campo[]=Marcas,id_marca;%@ 
	@%set:totalizar_cond_valor[]=Marcas.id_marca;%@ 
	@%set:_inm_count_times=3;%@
	@%set:_inm_count_reset=1;%@
	-->
	<table class="full">
	<tr> 
	@%where:nombre|TotalesAgente;nodb|nodb_totalizar;%@
	<td class="etiqueta">@%db:nombre_campo%@:</td>
	<td align="right">@%db:valor_campo;%@</td>
	@%if:inm_count;%@
		</tr><tr>
	@%end-if:%@
	@%end-where:%@

	</tr>
	</table>
	@%end-if:%@

	@%if:cambia_ruptura;Clientes.id_cliente;st[cl_search];%@
	<!-- Cerramos la tabla abierta por cambio de cliente -->
		@%if:esta_vacio;inicio;tabla_cerrada;%@
	</table>
		@%end-if:%@
	<br>
	<table class="full">
	<tr> 
	<td class="titulotb" align="right">Client:</td>
	<td colspan="3"><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@">@%db:Clientes.razon_social;%@</a> (@%db:Clientes.id_cliente;%@)
	@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</td>
	</tr>

	<tr> 
	<td class="titulotb">NSF:</td>
	<td >@%db:Clientes.cif;%@</td>
	<td class="titulotb">Direction:</td>
	<td >@%db:Clientes.direccion_facturacion;%@
	@%db:Clientes.poblacion;%@ @%db:Clientes.cp;%@ @%db:Clientes.provincia;%@
	</td>
	</table>
	<!-- 
	@%set:totalizar_campo=Clientes,id_cliente;%@ 
	@%set:totalizar_valor=Clientes.id_cliente;%@ 
	@%set:totalizar_cond_campo[]=Agentes,id_agente;%@ 
	@%set:totalizar_cond_valor[]=Agentes.id_agente;%@ 
	@%set:totalizar_cond_campo[]=Familia_articulos,id_familia;%@ 
	@%set:totalizar_cond_valor[]=Familia_articulos.id_familia;%@ 
	@%set:totalizar_cond_campo[]=Marcas,id_marca;%@ 
	@%set:totalizar_cond_valor[]=Marcas.id_marca;%@ 
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
	@%end-if:%@

	@%if:esta_vacio;cambio_ruptura;inicio;%@
	@%else:%@
	<br>
	<table class="full">
	<thead class="informe">
	<tr> 
	<td ><a href="?_search_sort=Articulos.id_articulo">ID<img src="imag/pixel.png" class="@%func:class_searchsort;Articulos.id_articulo;%@" /></a></td>
	<td ><a href="?_search_sort=Articulos.nombre">Article<img src="imag/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
	<td ><a href="?_search_sort=cantidad_pedida">Demandée<img src="imag/pixel.png" class="@%func:class_searchsort;cantidad_pedida;%@" /></a></td>
	<td ><a href="?_search_sort=cantidad_recibida">Reçue<img src="imag/pixel.png" class="@%func:class_searchsort;cantidad_recibida;%@" /></a></td>
	<td ><a href="?_search_sort=cantidad_facturada">Facturée<img src="imag/pixel.png" class="@%func:class_searchsort;cantidad_facturada;%@" /></a></td>
	<td ><a href="?_search_sort=precio_medio">Prix Moyen<img src="imag/pixel.png" class="@%func:class_searchsort;precio_medio;%@" /></a></td>
	<td ><a href="?_search_sort=precio_maximo">Prix Maximal<img src="imag/pixel.png" class="@%func:class_searchsort;precio_maximo;%@" /></a></td>
	<td ><a href="?_search_sort=precio_minimo">Prix Minimal<img src="imag/pixel.png" class="@%func:class_searchsort;precio_minimo;%@" /></a></td>
	</tr>
	</thead>
	<tbody class="informe" >
	@%else:%@
	<tbody class="informe" >
	@%end-if:%@

	<!-- @%set:inicio=0;%@ -->
<tr>
<td >@%db:Articulos.id_articulo;%@</td>
<td >@%db:Articulos.nombre;%@</td>
<td align="right">@%db:cantidad_pedida;%@</td>
<td align="right">@%db:cantidad_recibida;%@</td>
<td align="right">@%db:cantidad_facturada;%@</td>
<td align="right">@%db:precio_medio;%@</td>
<td align="right">@%db:precio_maximo;%@</td>
<td align="right">@%db:precio_minimo;%@</td>
</tr>

@%end-where:%@

</table>
