
@%plt:botonera;%@

<div id="AccionesListado"><ul>
<li><a href="#" onClick="return onHRefClick('bo_recorridos','accion_ejecutar', 'Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
</ul></div>

 <form name="bo_recorridos" action="?seccion=bo_recorridos" method="post">
 <input type="hidden" name="accion_ejecutar" value="Cambio_fechas" />
<table class="full">
<thead>
<tr>
<td></td>
<td ><a href="?_search_sort=Rutas.nombre" >Ruta<img src="images/pixel.png" class="@%func:class_searchsort;Rutas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=efectividad" >% Efectivitat<img src="images/pixel.png" class="@%func:class_searchsort;efectividad;%@" /></a></td>
<td ><a href="?_search_sort=Recorridos.fecha" >Data<img src="images/pixel.png" class="@%func:class_searchsort;Recorridos.fecha;%@" /></a> </td>
<td ><a href="?_search_sort=numero_clientes" >N� Clients<img src="images/pixel.png" class="@%func:class_searchsort;numero_clientes;%@" /></a></td>
<td ><a href="?_search_sort=Agentes.nombre" >Agent<img src="images/pixel.png" class="@%func:class_searchsort;Agentes.nombre;%@" /></a> </td>
<td ><a href="?_search_sort=numero_pedidos" >N� Comandes<img src="images/pixel.png" class="@%func:class_searchsort;numero_pedidos;%@" /></a> </td>
<td >Total base imposable</td>
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

<td class="check"> <input type="checkbox" name="registro_borrar[@%db:Recorridos.id_recorrido%@]" value="@%db:Recorridos.id_recorrido%@" /></td>
<td><a href="?seccion=modif_recorridos&id_recorrido=@%db:Recorridos.id_recorrido;%@">@%db:Rutas.nombre;%@</a></td>
<td>@%db:efectividad%@ %</td>
<td><input type="text" name="registro[@%db:Recorridos.id_recorrido%@][fecha]" value="@%db:colocar_fecha{Recorridos.fecha}%@" class="fecha" /></td>
<td>@%db:numero_clientes;%@ </td>
<td><a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@" >@%db:Agentes.nombre;%@</a></td>
<td>@%db:numero_pedidos;%@</td>
<td>@%func:fmt_lcmon;total_base_pedidos;%@</td>
</tr>
 @%end-where:%@

</tbody>
</table>
<input type="hidden" name="Guardar" value="Guardar" />
</form>

 @%plt:botonera;%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('bo_recorridos');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
</ul></div>
 
