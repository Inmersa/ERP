 <form name="modif_gastos" action="?seccion=bo_gastos" method="post">
 <input type="hidden" name="registro[id_gasto]" value="@%db:Gastos.id_gasto;%@">
 <input type="hidden" name="estado" value="1">
<table class="full">
 <tr><td class="etiqueta" >Name:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Gastos.nombre;%@" class="insertext" size="55"></td>
 </tr>
<tr><td class="etiqueta">Description:</td>
<td><textarea name="registro[descripcion]" cols="75" rows="7">@%db:Gastos.descripcion;%@</textarea></td>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_gastos');" >Save</a>
 <a href="#" onClick="return resetForm('modif_gastos');" >Undo changes</a> 
 <a href="?seccion=bo_gastos&estado=2&registro[id_gasto]=@%db:Gastos.id_gasto%@" 
 	onClick="return confirm('Are you sure that do you want to delete the selected registries??');" >Delete</a></div>
