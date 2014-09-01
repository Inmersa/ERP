@%where:tabla|Certificados;%@

 <form name="modif_certificados" action="?seccion=bo_certificados" method=post>
 <input type="hidden" name="registro[id_certificado]" value="@%db:Certificados.id_certificado;%@">
 <input type="hidden" name="estado" value="1">
 <!--@%db:Certificados.id_certificado;%@-->
<table class="full">
 <tr><td class="etiqueta" >Nome:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Certificados.nombre;%@" class="insertext" size="40"></td>
 </tr>
 <tr><td class="etiqueta" >Descrição:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Certificados.descripcion;%@" class="insertext" size="65"></td>
 </tr>
 <tr><td class="etiqueta" >Responsável:</td>
 <td ><input type="text" name="registro[responsable]" value="@%db:Certificados.responsable;%@" class="insertext" size="40"></td>
 </tr>
 </table>

 <div class="enviar"> 
 <a href="#" onClick="return sendForm('modif_certificados');" >Guardar</a> 
 <a href="#" onClick="return resetForm('modif_certificados');" >Desfazer Alterações</a> 
 <a href="?seccion=bo_certificados&estado=2&registro[id_certificado]=@%db:Certificados.id_certificado%@" 
 	onClick="return confirm('¿É você certo que você quer suprimir registros selecionados?');" >Eliminar</a></div>
 </form>
@%end-where:%@ 
