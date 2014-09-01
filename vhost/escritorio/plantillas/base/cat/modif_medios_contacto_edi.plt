 <form name="modif_medios_contacto" action="?seccion=bo_medios_contacto" method="post">
 <input type="hidden" name="registro[id_medio_cto]" value="@%db:Medios_contacto.id_medio_cto;%@">
 <input type="hidden" name="estado" value="1">
<table class="full">
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Medios_contacto.nombre;%@" class="insertext" size="55"></td></tr>
<tr><td class="etiqueta">Descripció:</td>
<td><textarea name="registro[descripcion]" cols="75" rows="7">@%db:Medios_contacto.descripcion;%@</textarea></td>
 </tr>
 </table>
 </form>
 <div class="enviar"
 <a href="#" onClick="return sendForm('modif_medios_contacto');" >Guardar</a> 
 <a href="#" onClick="return sendForm('modif_medios_contacto');" >Desfer canvis</a> 
 <a href="?seccion=bo_medios_contacto&estado=2&registro[id_medio_cto]=@%db:Medios_contacto.id_medio_cto%@" 
 	onClick="return confirm('¿Està segur que desitja esborrar els registres seleccionats?');" >Esborrar</a></div>
