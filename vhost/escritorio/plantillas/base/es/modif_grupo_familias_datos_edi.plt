 <form name="modif_grupo_familias" action="?seccion=bo_grupo_familias" method="post">
 <input type="hidden" name="registro[id_grupo_familia]" value="@%db:Grupo_familias.id_grupo_familia;%@">
 <input type="hidden" name="estado" value="1">
<table class="full">
 <tr><td class="etiqueta" >Nombre:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Grupo_familias.nombre;%@" class="insertext" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Descripción:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Grupo_familias.descripcion;%@" class="insertext" size="55"></td>
 </tr>
 </table>
 </form>

 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_grupo_familias');" >Guardar</a> 
 <a href="#" onClick="return resetForm('modif_grupo_familias');" >Deshacer Cambios</a> 
 <a href="?seccion=bo_grupo_familias&estado=2&registro[id_grupo_familia]=@%db:Grupo_familias.id_grupo_familia%@" 
 	onClick="return confirm('¿Está ud. seguro de que desea borrar los registros seleccionados?');" >Borrar</a> </div>
