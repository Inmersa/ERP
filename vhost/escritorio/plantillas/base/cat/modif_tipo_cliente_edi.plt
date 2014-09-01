


<form name="modif_tipo_cliente" action="?seccion=bo_tipo_cliente" method="post">
<input type="hidden" name="registro[id_tipo_cliente]" value="@%db:Tipo_cliente.id_tipo_cliente;%@">
<input type="hidden" name="estado" value="1">
 <!--@%db:Tipo_cliente.id_tipo_cliente;%@-->
<table class="full">
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Tipo_cliente.nombre;%@" class="insertext" size="40"></td>
 </tr>
 <tr><td class="etiqueta" >Descripció:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Tipo_cliente.descripcion;%@" size="70" class="insertext"></td>
 </tr>
 <tr><td class="etiqueta" >IVA:</td>
 <td ><input type="checkbox" name="registro[aplicar_iva]" value="1" @%db:check_flag{Tipo_cliente.aplicar_iva}%@
 	>(@%db:si_no_flag{Tipo_cliente.aplicar_iva};%@)</td>
 </tr>
 <tr><td class="etiqueta" >Recàrrec equivalent:</td>
 <td ><input type="checkbox" name="registro[aplicar_recargo]" value=1 @%db:check_flag{Tipo_cliente.aplicar_recargo}%@
 	>(@%db:si_no_flag{Tipo_cliente.aplicar_recargo};%@)</td>
 </tr>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_tipo_cliente');" >Guardar</a> 
 <a href="#" onClick="return resetForm('modif_tipo_cliente');" >Desfer canvis</a> 
 <a href="?seccion=bo_tipo_cliente&estado=2&registro[id_tipo_cliente]=@%db:Tipo_cliente.id_tipo_cliente%@" 
 	onClick="return confirm('¿Està segur que desitja esborrar els registres seleccionats?');" >Esborrar</a></div>
