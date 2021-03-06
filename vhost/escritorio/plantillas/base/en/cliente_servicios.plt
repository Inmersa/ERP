
<div class="tituloseccion">Client Services 
@%where:nombre|Cliente;tabla|Clientes;where|id_cliente = $id_cliente;%@
@%db:Clientes.razon_social;%@ (ID: @%db:Clientes.id_cliente;%@) 
@%end-where:%@

</div>

@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedAction;Clientes_recursos;new;%@
<li><a href="?seccion=bo_articulos&modo_seleccion=1&many=1&target=nuevo_servicio_cliente&recursos=NOTNULL" class="nuevo"
	><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
@%end-if:%@
@%if:AllowedAction;Clientes_recursos;del;%@
<li><a href="#" onClick="return sendForm('servicios','accion_ejecutar','Borrar');" class="borrar"
	><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
@%end-if:%@
</ul></div>

<form name="servicios" action="?seccion=@%get:_krn_ss_name;%@" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />

<table class="full">
<thead>
<tr>
@%if:AllowedAction;Clientes_recursos;del;%@
 <td >&nbsp;</td>
@%end-if:%@
 <td ><a href="?_search_sort=Recursos.nombre" >Resource<img src="images/pixel.png" class="@%func:class_searchsort;Recursos.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Articulos.nombre" >Article<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
 <td ><a href="?_search_sort=Clientes_recursos.fecha_inicio" >Starting date<img src="images/pixel.png" 
 	class="@%func:class_searchsort;Clientes_recursos.fecha_inicio;%@" /></a></td>
 <td ><a href="?_search_sort=Clientes_recursos.fecha_fin" >Last date<img src="images/pixel.png" 
 	class="@%func:class_searchsort;Clientes_recursos.fecha_fin;%@" /></a></td>
 <td ><a href="?_search_sort=Estados_servicio.nombre" >Service Status<img src="images/pixel.png" class="@%func:class_searchsort;Estados_servicio.nombre;%@" /></a></td>
</tr>
</thead>
<tbody>
 @%where:tabla|Clientes_servicios;nombre|busc;order|Articulos.nombre asc, Clientes_recursos.fecha_inicio asc;no_results|1;%@
<tr > 
 @%if:AllowedAction;Clientes_recursos;del;%@
 <td class="check"><input type="checkbox" name="clientes_recursos[@%db:Clientes_recursos.id_cliente_recurso;%@][id_cliente_recurso]" 
 	value="@%db:Clientes_recursos.id_cliente_recurso;%@" /></td>
 @%end-if:%@
 <td >
 @%if:AllowedAction;Clientes_recursos;edit;%@
 <a href="?seccion=ficha_servicio_cliente&id=@%db:Clientes_recursos.id_cliente_recurso;%@" >@%db:Recursos.nombre;%@ (@%db:Tipos_recurso.nombre;%@)</a>
 @%else:%@
 @%db:Recursos.nombre;%@ (@%db:Tipos_recurso.nombre;%@)
 @%end-if:%@
 </td>
 <td>@%db:Articulos.nombre;%@</td>
 <td >@%db:colocar_fecha{Clientes_recursos.fecha_inicio};%@</td>
 <td >@%db:colocar_fecha{Clientes_recursos.fecha_fin};%@</td>
 <td >@%db:Estados_servicio.nombre;%@</td>
</tr>
@%if:esta_vacio;Clientes_recursos.notas;%@
@%else:%@
<tr><td colspan="6" >@%db:reemplazar_salto{Clientes_recursos.notas};%@</td></tr>
@%end-if:%@

@%end-where:%@ 
 
</tbody>
</table>
</form>

 @%plt:botonera%@

