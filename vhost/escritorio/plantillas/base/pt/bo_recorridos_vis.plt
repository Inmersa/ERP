
@%plt:botonera;%@

<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Rutas.nombre" >Rota<img src="imag/pixel.png" class="@%func:class_searchsort;Rutas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=efectividad" >% Efic�cia<img src="imag/pixel.png" class="@%func:class_searchsort;efectividad;%@" /></a></td>
<td ><a href="?_search_sort=Recorridos.fecha" >Data<img src="imag/pixel.png" class="@%func:class_searchsort;Recorridos.fecha;%@" /></a> </td>
<td ><a href="?_search_sort=numero_clientes" >N� Cliente<img src="imag/pixel.png" class="@%func:class_searchsort;numero_clientes;%@" /></a></td>
<td ><a href="?_search_sort=Agentes.nombre" >Agente<img src="imag/pixel.png" class="@%func:class_searchsort;Agentes.nombre;%@" /></a> </td>
<td ><a href="?_search_sort=numero_pedidos" >N� Encomenda<img src="imag/pixel.png" class="@%func:class_searchsort;numero_pedidos;%@" /></a> </td>
<td >Total do Valor Tribut�vel</td>
</tr>
</thead>
<tbody>
 @%where:tabla|Recorridos;nombre|busc;no_results|1;order|Recorridos.fecha desc;%@
 <!-- aqui viene el registro 
@%if:esta_vacio;numero_pedidos;%@
@%set:total_base_pedidos=0;%@
@%set:numero_pedidos=0;%@
@%set:efectividad=0;%@
@%else:%@
@%where:tabla|Citas;nombre|pedidos;group|Citas.id_recorrido;%@
@%db:Citas.id_pedido%@
@%db:SUM(IVAs.monto) as 'base_pedidos';%@
@%set:total_base_pedidos=base_pedidos%@
@%end-where:%@

@%end-if:%@
 -->
@%if:!esta_vacio;Recorridos.h_inicio;Recorridos.h_fin;%@
	@%if:esta_vacio;Recorridos.h_fin;%@
	<tr class="impropio" >
	@%else:%@
	<tr class="resalte" >
	@%end-if:%@
@%else:%@
<tr>
@%end-if:%@
<td><a href="?seccion=modif_recorridos&id_recorrido=@%db:Recorridos.id_recorrido;%@">@%db:Rutas.nombre;%@</a></td>
<td>@%db:efectividad%@ %</td>
<td>@%db:colocar_fecha{Recorridos.fecha}%@</td>
<td>@%db:numero_clientes;%@ </td>
<td><a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@" >@%db:Agentes.nombre;%@</a></td>
<td>@%db:numero_pedidos;%@</td>
<td>@%get:total_base_pedidos;%@</td>
</tr>
 @%end-where:%@

</tbody>
</table>

 @%plt:botonera;%@

