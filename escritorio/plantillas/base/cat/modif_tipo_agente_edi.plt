 <form name="modif_tipo_agente" action="?seccion=bo_tipo_agente" method="post">
 <input type="hidden" name="registro[id_tipo_agente]" value="@%db:Tipo_agente.id_tipo_agente;%@">
 <input type="hidden" name="estado" value="1">
 <!--@%db:Tipo_agente.id_tipo_agente;%@-->
<table class="full">
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Tipo_agente.nombre;%@" class="insertext" size="40"></td>
 </tr>
 <tr><td class="etiqueta" >Descripci�:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Tipo_agente.descripcion;%@" class="insertext" size="65"></td>
 </tr>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_tipo_agente');" >Guardar</a> 
 <a href="#" onClick="return resetForm('modif_tipo_agente');" >Desfer canvis</a> 
 <a href="?seccion=bo_tipo_agente&estado=2&registro[id_tipo_agente]=@%db:Tipo_agente.id_tipo_agente%@" 
 	onClick="return confirm('�Est� segur que desitja esborrar els registres seleccionats?');" >Esborrar</a> </div>
