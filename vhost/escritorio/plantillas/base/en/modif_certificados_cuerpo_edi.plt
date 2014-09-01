@%where:tabla|Certificados;%@

 <form name="modif_certificados" action="?seccion=bo_certificados" method=post>
 <input type="hidden" name="registro[id_certificado]" value="@%db:Certificados.id_certificado;%@">
 <input type="hidden" name="estado" value="1">
 <!--@%db:Certificados.id_certificado;%@-->
<table class="full">
 <tr><td class="etiqueta" >Name:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Certificados.nombre;%@" class="insertext" size="40"></td>
 </tr>
 <tr><td class="etiqueta" >Description:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Certificados.descripcion;%@" class="insertext" size="65"></td>
 </tr>
 <tr><td class="etiqueta" >Person in charge:</td>
 <td ><input type="text" name="registro[responsable]" value="@%db:Certificados.responsable;%@" class="insertext" size="40"></td>
 </tr>
 </table>

 <div class="enviar"> 
 <a href="#" onClick="return sendForm('modif_certificados');" >Save</a> 
 <a href="#" onClick="return resetForm('modif_certificados');" >Undo changes</a> 
 <a href="?seccion=bo_certificados&estado=2&registro[id_certificado]=@%db:Certificados.id_certificado%@" 
 	onClick="return confirm('Are you sure that do you want to delete the selected registries?');" >Delete</a></div>
 </form>
@%end-where:%@ 
