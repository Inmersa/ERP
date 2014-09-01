@%where:tabla|Ayuda;%@
 <div class="barraoscura"><div class="titsuperior">&gt; MODIFICAR AYUDA</div>
 <div class="alinder">
 @%if:AllowedLink;bo_ayuda_nuevo;%@
 <a href="?seccion=bo_ayuda_nuevo">Nuevo</a>
 @%end-if:%@
 </div></div>

 <form name="modif_ayuda" action="?seccion=bo_ayuda" method="post">
 <input type="hidden" name="estado" value="3">
 <input type="hidden" name="old_idsub" value="@%db:Ayuda.id_sub%@">
 <table class="full">
 <tr><td class="etiqueta" >Seccion:</td>
 <td > 
<!-- @%set:_selected_value=Ayuda.id_sub%@ -->
 <select name="registro[id_sub]" class="insertext" >
 @%where:db|conf;tabla|Sub_Secc;nolink|1;where|backoffice = 1;%@
 <option value="@%db:Sub_Secc.id_sub_secc;%@"
@%db:selected_value{Sub_Secc.id_sub_secc}%@
>@%db:Sub_Secc.nombre_visual;%@(@%db:Sub_Secc.nombre%@)</option>
 @%end-where:%@

 </select>
 </td>
 <tr><td class="etiqueta" >Nombre:</td>
 <td ><input type="text" name="registro[nombre]" class="insertext" size="40" value="@%db:Ayuda.nombre%@"></td>
 </tr>
 <tr><td class="etiqueta" >Antetítulo:</td>
 <td ><input type="text" name="registro[antetitulo]" class="insertext" size="65" value="@%db:Ayuda.antetitulo%@"></td>
 </tr>
 <tr><td class="etiqueta" >Título:</td>
 <td ><input type="text" name="registro[titulo]" class="insertext" size="65" value="@%db:Ayuda.titulo%@"></td>
 </tr>
 </tr><td class="etiqueta" >Activo:</td>
 <td ><input type="checkbox" name="registro[activo]" class="insertext" value="1" @%db:check_flag{Ayuda.activo}%@></td>
 </tr>
 <tr><td class="etiqueta" >Cuerpo:</td>
 <td ><textarea name="registro[cuerpo]" class="insertext" cols="80">@%db:Ayuda.cuerpo%@</textarea></td>
 </tr>
 </table>
 <table class="full">
 <tr><td class="check" >&nbsp;</td>
 <td class="caption">Epigrafes</td>
 <td class="caption" align="right"><a href="?seccion=bo_ayuda_nuevo_epigrafe&id_sub=@%db:Ayuda.id_sub%@" class="accesos">Nuevo</a></td>
 <td class="caption"><a href="#" onClick="return onHRefClick('modif_ayuda','estado','2','bo_ayuda_modif','¿Está ud. seguro de que desea borrar los registros seleccionados?');"
 	>Borrar seleccionados</a></td></tr>
 @%where:tabla|Ayuda_epigrafes;%@
 <tr>
 <td class="check"><input type="checkbox" name="borrar_epigrafes[@%db:Ayuda_epigrafes.id_epigrafe%@]"
 value="@%db:Ayuda_epigrafes.id_epigrafe%@"></td>
 <td colspan="3"><a href="?seccion=bo_ayuda_modif_epigrafe&id_epigrafe=@%db:Ayuda_epigrafes.id_epigrafe%@" >@%db:Ayuda_epigrafes.titulo%@</a></td>
 </tr>
 @%end-where:%@

 </table>
 </form>
<div class="enviar">
<a href="#" onClick="return sendForm('modif_ayuda');" > Guardar</a> 
<a href="#" onClick="return resetForm('modif_ayuda');" > Deshacer Cambios</a> </div>
