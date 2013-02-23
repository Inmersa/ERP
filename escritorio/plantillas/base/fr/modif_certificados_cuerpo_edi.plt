@%where:tabla|Certificados;%@

 <form name="modif_certificados" action="?seccion=bo_certificados" method=post>
 <input type="hidden" name="registro[id_certificado]" value="@%db:Certificados.id_certificado;%@">
 <input type="hidden" name="estado" value="1">
 <!--@%db:Certificados.id_certificado;%@-->
<table class="full">
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Certificados.nombre;%@" class="insertext" size="40"></td>
 </tr>
 <tr><td class="etiqueta" >Description:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Certificados.descripcion;%@" class="insertext" size="65"></td>
 </tr>
 <tr><td class="etiqueta" >Reponsable:</td>
 <td ><input type="text" name="registro[responsable]" value="@%db:Certificados.responsable;%@" class="insertext" size="40"></td>
 </tr>
 </table>

 <div class="enviar"> 
 <a href="#" onClick="return sendForm('modif_certificados');" >Garder</a> 
 <a href="#" onClick="return resetForm('modif_certificados');" >Défaire changement</a> 
 <a href="?seccion=bo_certificados&estado=2&registro[id_certificado]=@%db:Certificados.id_certificado%@" 
 	onClick="return confirm('Êtes-vous sûr que vous voulez supprimer des enregistrements choisis?');" >Effacer</a></div>
 </form>
@%end-where:%@ 
