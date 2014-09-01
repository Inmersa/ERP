
@%plt:botonera%@
<form name="listado_bajas" action="?seccion=bo_maestro_bajas_almacen" method="post">
 <input type="hidden" name="estado" value="2" />
 
<table class="full">

<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Descripció</td>
</tr>
 @%where:tabla|Bajas_almacen;nombre|busc;no_results|1;%@

<tr><td class="check"> <input type="checkbox" name="registro_borrar[]" value="@%db:Bajas_almacen.id_baja_almacen;%@" /></td>
<td class="etiqueta"><a href="?seccion=modif_maestro_bajas_almacen&id_baja_almacen=@%db:Bajas_almacen.id_baja_almacen;%@">@%db:Bajas_almacen.nombre;%@</a></td>
<td>@%db:Bajas_almacen.descripcion;%@</td>
</tr>


@%end-where:%@




 </table>
 </form>

@%plt:botonera%@
<div class="enviar"><a href="javascript: document.forms['listado_bajas'].submit();">Esborrar seleccionats</a></div>


