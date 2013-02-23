
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;bo_importar_almacenes;%@
<!-- li><a href="?seccion=bo_importar_almacenes" class="importaralmacen"><img src="images/pixel.png" class="icono" /><span>Import registries</span></a></li -->
@%end-if:%@
@%if:AllowedLink;nuevo_almacenes;%@
<li><a href="?seccion=nuevo_almacenes" class="nuevo"><img src="images/pixel.png" class="icono" /><span>New Warehouse</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return onHRefClick('bo_almacenes','accion_ejecutar','Borrar');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>

<form name="bo_almacenes" method="post" action="?seccion=bo_almacenes">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<input type="hidden" name="accion_ejecutar" value="Borrar" />
<table class="full">
<tr>
<td></td>
<td class="caption">Name</td>
<td class="caption">Telephone</td>
<td class="caption">e-mail</td>
<td class="caption">Contact person</td>
</tr>
@%where:tabla|Almacenes;nombre|busc;no_results|1;order|Almacenes.nombre;%@
<tr><td class="check"> 
<input type="checkbox" name="almacen_borrar[@%db:Almacenes.id_almacen;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_almacenes&id_almacen=@%db:Almacenes.id_almacen;%@">@%db:Almacenes.nombre;%@</a></td>
<td>@%db:Almacenes.telefono;%@</td>
<td>@%db:Almacenes.email;%@</td>
<td>@%db:Almacenes.persona_contacto;%@ (@%db:Almacenes.cargo_persona_contacto;%@)</td>
</tr>
 @%end-where:%@

 </table>
 </form>

 @%plt:botonera%@

