
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="#" onclick="return onHRefClick('proveedores','accion_ejecutar','asociar_proveedores');" class="enviar" 
	><img src="imag/pixel.png" class="icono" /><span> Asigner</span></a></li>
</ul></div>

<form name="proveedores" action="?seccion=modif_articulos" method="post">
<input type="hidden" name="accion_ejecutar" value="asociar_proveedores" />
<table class="full">
<thead>
<tr>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('proveedores_seleccionados');"  /></td>
<td ><a href="?_search_sort=Proveedores.nombre" >Nom<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.nombre;%@" /></a></td>
<td >Prix</td>
<td >Pr.Rt Officie</td>
<td >Pr.Pub Officie</td>
<td >Référence</td>
</tr>
</thead>
<!-- @%set:_store_id_reset = 1;%@ -->
<tbody>
@%where:tabla|Proveedores;nombre|busc;%@
<tr>
<td class="check"> 
@%if:!store_id_check;Proveedores.id_proveedor;%@ 
<input type="checkbox" name="proveedores_seleccionados[@%db:Proveedores.id_proveedor;%@][id_proveedor]" value="1" />
@%end-if:%@
</td>
<td class="etiqueta"><a href="?seccion=modif_proveedor&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.nombre;%@</a></td>
<td> <input type="text" name="proveedores_seleccionados[@%db:Proveedores.id_proveedor;%@][precio]" value="0" size="10" /></td>
<td> <input type="text" name="proveedores_seleccionados[@%db:Proveedores.id_proveedor;%@][PV_oficial]" value="0" size="10" /></td>
<td> <input type="text" name="proveedores_seleccionados[@%db:Proveedores.id_proveedor;%@][PVP_oficial]" value="0" size="10" /></td>
<td> <input type="text" name="proveedores_seleccionados[@%db:Proveedores.id_proveedor;%@][referencia]" value="0" size="10" /></td>
</tr>
@%end-where:%@

 </tbody>
 </table>
 </form>

@%plt:botonera%@
 
