
<form name="modif_maestro_bajas_almacen" action="?seccion=bo_maestro_bajas_almacen" method=post>
<input type="hidden" name="registro[id_baja_almacen]" value="@%db:Bajas_almacen.id_baja_almacen;%@">
<input type="hidden" name="estado" value="1">
<!--@%db:Bajas_almacen.id_baja_almacen;%@-->
<table class="full">
 <tr> 
 <td class="etiqueta">Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Bajas_almacen.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descripci�:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Bajas_almacen.descripcion;%@" class="insertext" size="55"></td>
 </tr>
</table>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_maestro_bajas_almacen');">Guardar</a> 
 <a href="#" onClick="return resetForm('modif_maestro_bajas_almacen');">Desfer canvis</a>
 <a href="?seccion=bo_maestro_bajas_almacen&estado=2&registro[id_baja_almacen]=@%db:Bajas_almacen.id_baja_almacen%@" 
 	onClick="return confirm('�Est� segur que desitja esborrar els registres seleccionats?');return false;" class="accesos">Esborrar</a></div>
 </form>
