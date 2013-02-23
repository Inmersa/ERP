
@%plt:botonera%@

<div id="AccionesListado" ><ul>
@%if:AllowedAction;Pedidos;new;%@
<li><a href="#" onClick="return onHRefClick('pedidos_tipo_cliente',null,null,'hacer_pedido&tipo=1&nuevo=1&pedido=1');" class="nuevo" 
	><img src="imag/pixel.png" class="icono" /><span>Efectuar Encomenda</span></a></li>
@%set:permitir_selecciones = 1;%@
@%end-if:%@
@%if:AllowedAction;Pedidos_tipo_cliente;del;%@
<li><a href="#" onclick="return sendForm('pedidos_tipo_cliente');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
@%set:permitir_selecciones = 1;%@
@%end-if:%@
</ul></div>

<form name="pedidos_tipo_cliente" action="?seccion=bo_pedidos_tipo_cliente" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<table class="full">
<thead>
 <tr>
 <td ><a href="?_search_sort=Pedidos.referencia" >Código<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
 @%if:!esta_vacio;permitir_selecciones;%@
 <td ></td>
 @%end-if:%@
 <td ><a href="?_search_sort=Pedidos_tipo_cliente.nombre" >Nome<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos_tipo_cliente.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Pedidos.fecha" >Data<img src="imag/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
 <td ><a href="?_search_sort=Direcciones_entrega.nombre" 
 	>Endereço de Entrega<img src="imag/pixel.png" class="@%func:class_searchsort;Direcciones_entrega.nombre;%@" /></a> </td>
 <td ><a href="?_search_sort=monto_pedido" >Montante<img src="imag/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
 </tr>
</thead>
<tbody>
 @%where:tabla|Pedidos_tipo_cliente;nombre|busc;no_results|1;order|Pedidos.fecha desc%@
 <tr>
 <td>@%db:not_empty{Pedidos.referencia};%@</td>
 @%if:!esta_vacio;permitir_selecciones;%@
 <td class="check"><input type="checkbox" name="pedidos_tipo_cliente[@%db:Pedidos_tipo_cliente.id_pedido%@]" value="1" /></td>
 @%end-if:%@
 <td><a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos_tipo_cliente.id_pedido%@">@%db:Pedidos_tipo_cliente.nombre;%@ </a></td>
 <td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
 <td>@%db:Direcciones_entrega.nombre;%@</td>
 <td>@%db:monto_pedido%@ </td>
 </tr>
 @%end-where:%@
 
</tbody>
</table>
</form>

@%plt:botonera%@

