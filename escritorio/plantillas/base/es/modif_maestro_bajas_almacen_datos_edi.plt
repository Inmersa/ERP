
<form name="modif_maestro_bajas_almacen" action="?seccion=bo_maestro_bajas_almacen" method=post>
<input type="hidden" name="registro[id_baja_almacen]" value="@%db:Bajas_almacen.id_baja_almacen;%@">
<input type="hidden" name="estado" value="1">
<!--@%db:Bajas_almacen.id_baja_almacen;%@-->
<table class="full">
 <tr> 
 <td class="etiqueta">Nombre:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Bajas_almacen.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descripci�n:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Bajas_almacen.descripcion;%@" class="insertext" size="55"></td>
 </tr>
</table>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_maestro_bajas_almacen');">Guardar</a> 
 <a href="#" onClick="return resetForm('modif_maestro_bajas_almacen');">Deshacer Cambios</a>
 <a href="?seccion=bo_maestro_bajas_almacen&estado=2&registro[id_baja_almacen]=@%db:Bajas_almacen.id_baja_almacen%@" 
 	onClick="return confirm('�Est� ud. seguro de que desea borrar los registros seleccionados?');return false;" class="accesos">Borrar</a></div>
 </form>
