 <form name="modif_grupo_rutas" action="?seccion=bo_grupos_rutas" method="post">
 <input type="hidden" name="registro[id_grupo_ruta]" value="@%db:Grupo_rutas.id_grupo_ruta;%@">
 <input type="hidden" name="estado" value="1">
<table class="full">
 <tr><td class="etiqueta" >Nombre:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Grupo_rutas.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descripcci�n:</td>
 <td><textarea name="registro[descripcion]" cols="75" rows="7">@%db:Grupo_rutas.descripcion;%@</textarea></td>
 </tr>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_grupo_rutas');" >Guardar</a> 
 <a href="#" onClick="return resetForm('modif_grupo_rutas');" >Deshacer Cambios</a> 
 <a href="?seccion=bo_grupos_rutas&estado=2&registro[id_grupo_ruta]=@%db:Grupo_rutas.id_grupo_ruta%@" 
 	onClick="return confirm('�Est� ud. seguro de que desea borrar los registros seleccionados?');" >Borrar</a></div>
