
@%plt:botonera%@
<div id="AccionesListado" ><ul>
@%if:AllowedAction;Pedidos;new;%@
<li><a href="#" onClick="return onHRefClick('pedidos_tipo_proveedor',null,null,'hacer_pedido_compra&tipo=1&nuevo=1&pedido=1');" class="nuevo" 
	><img src="images/pixel.png" class="icono" /><span>Fer comanda</span></a></li>
@%set:permitir_selecciones = 1;%@
@%end-if:%@
@%if:AllowedAction;Pedidos_tipo_proveedor;del;%@
<li><a href="#" onclick="return sendForm('pedidos_tipo_proveedor');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
@%set:permitir_selecciones = 1;%@
@%end-if:%@
</ul></div>

<form name="pedidos_tipo_proveedor" action="#" method="post">
<input type="hidden" name="Borrar" value="Borrar" />
<table class="full">
<thead>
<tr>
<td ><a href="?_search_sort=Pedidos.referencia" >Refer�ncia<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.referencia;%@" /></a></td>
 @%if:!esta_vacio;permitir_selecciones;%@
 <td ></td>
 @%end-if:%@
<td ><a href="?_search_sort=Pedidos_tipo_proveedor.nombre" >Nom<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos_tipo_proveedor.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.fecha" >Data<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.fecha;%@" /></a></td>
<td ><a href="?_search_sort=Pedidos.referencia_externa" >Ref. Ext<img src="images/pixel.png" class="@%func:class_searchsort;Pedidos.referencia_externa;%@" /></a></td>
<td ><a href="?_search_sort=monto_pedido" >Import<img src="images/pixel.png" class="@%func:class_searchsort;monto_pedido;%@" /></a></td>
</tr>
</thead>
 @%where:tabla|Pedidos_tipo_proveedor;cf|cf_pedidos;nombre|busc;no_results|1;%@
<!-- aqui viene el registro -->
<tr>
<td>@%db:not_empty{Pedidos.referencia};%@</td>
 @%if:!esta_vacio;permitir_selecciones;%@
<td class="check"><input type="checkbox" name="pedidos_tipo_proveedor[@%db:Pedidos_tipo_proveedor.id_pedido%@]" value="1" /></td>
 @%end-if:%@
<td><a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos_tipo_proveedor.id_pedido;%@">@%db:Pedidos_tipo_proveedor.nombre;%@</a></td>
<td>@%db:colocar_fecha{Pedidos.fecha};%@</td>
<td>@%db:Pedidos.referencia_externa;%@</td>
<td>@%db:monto_pedido%@ </td>
</tr>
 @%end-where:%@

</table>
</form>

@%plt:botonera%@

