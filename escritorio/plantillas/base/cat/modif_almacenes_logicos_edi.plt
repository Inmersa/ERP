
<form name="modif_almacenes" action="?seccion=@%get:_krn_ss_name;%@" method="post" >
<input type="hidden" name="accione_ejecutar" value="Modificar" />

<fieldset class="fsficha">
<legend>Zonas Magatzem</legend>

<div id="AccionesEncabezado"><ul>
@%if:AllowedLink;nuevo_almacenes_logicos;%@
<li><a href="?seccion=nuevo_almacenes_logicos&id_almacen=@%get:id_almacen_promocion%@" class="nuevo" 
	><img src="images/pixel.png" class="icono" /><span>Afegir</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return onHRefClick('modif_almacenes','accion_ejecutar','Borrar');" class="borrar" 
	><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li> 
</ul></div>

<table class="full">
@%where:tabla|Almacenes_logicos;where|Almacenes_logicos.id_almacen = $id_almacen_promocion;%@
<tr>
<td class="check"><input type="checkbox" name="almacen_logico_borrar[@%db:Almacenes_logicos.id_almacen_logico;%@]" value="1" /></td>
<td><a href="?seccion=modif_almacenes_logicos&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@">@%db:Almacenes_logicos.nombre;%@</a></td>
</tr>
@%end-where:%@

</table>
</fieldset>
</form>

