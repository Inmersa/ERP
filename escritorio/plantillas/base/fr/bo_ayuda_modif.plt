@%where:tabla|Ayuda;%@
 <div class="barraoscura"><div class="titsuperior">&gt; Modifier</div>
 <div class="alinder">
 @%if:AllowedLink;bo_ayuda_nuevo;%@
 <a href="?seccion=bo_ayuda_nuevo">Nouveau</a>
 @%end-if:%@
 </div></div>

 <form name="modif_ayuda" action="?seccion=bo_ayuda" method="post">
 <input type="hidden" name="estado" value="3">
 <input type="hidden" name="old_idsub" value="@%db:Ayuda.id_sub%@">
 <table class="full">
 <tr><td class="etiqueta" >Section:</td>
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
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" class="insertext" size="40" value="@%db:Ayuda.nombre%@"></td>
 </tr>
 <tr><td class="etiqueta" >Avant-Titre:</td>
 <td ><input type="text" name="registro[antetitulo]" class="insertext" size="65" value="@%db:Ayuda.antetitulo%@"></td>
 </tr>
 <tr><td class="etiqueta" >Titre:</td>
 <td ><input type="text" name="registro[titulo]" class="insertext" size="65" value="@%db:Ayuda.titulo%@"></td>
 </tr>
 </tr><td class="etiqueta" >Actif:</td>
 <td ><input type="checkbox" name="registro[activo]" class="insertext" value="1" @%db:check_flag{Ayuda.activo}%@></td>
 </tr>
 <tr><td class="etiqueta" >Corp:</td>
 <td ><textarea name="registro[cuerpo]" class="insertext" cols="80">@%db:Ayuda.cuerpo%@</textarea></td>
 </tr>
 </table>
 <table class="full">
 <tr><td class="check" >&nbsp;</td>
 <td class="caption">Epigraphe</td>
 <td class="caption" align="right"><a href="?seccion=bo_ayuda_nuevo_epigrafe&id_sub=@%db:Ayuda.id_sub%@" class="accesos">Nouveau</a></td>
 <td class="caption"><a href="#" onClick="return onHRefClick('modif_ayuda','estado','2','bo_ayuda_modif','Êtes-vous sûr que vous voulez supprimer des enregistrements choisis?');"
 	>Elimier</a></td></tr>
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
<a href="#" onClick="return sendForm('modif_ayuda');" > Garder</a> 
<a href="#" onClick="return resetForm('modif_ayuda');" > Défaire changement</a> </div>
