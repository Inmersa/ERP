


<form name="modif_tipo_cliente" action="?seccion=bo_tipo_cliente" method="post">
<input type="hidden" name="registro[id_tipo_cliente]" value="@%db:Tipo_cliente.id_tipo_cliente;%@">
<input type="hidden" name="estado" value="1">
 <!--@%db:Tipo_cliente.id_tipo_cliente;%@-->
<table class="full">
 <tr><td class="etiqueta" >Name:</td>
 <td ><input type="text" name="registro[nombre]" value="@%db:Tipo_cliente.nombre;%@" class="insertext" size="40"></td>
 </tr>
 <tr><td class="etiqueta" >Description:</td>
 <td ><input type="text" name="registro[descripcion]" value="@%db:Tipo_cliente.descripcion;%@" size="70" class="insertext"></td>
 </tr>
 <tr><td class="etiqueta" >VAT:</td>
 <td ><input type="checkbox" name="registro[aplicar_iva]" value="1" @%db:check_flag{Tipo_cliente.aplicar_iva}%@
 	>(@%db:si_no_flag{Tipo_cliente.aplicar_iva};%@)</td>
 </tr>
 <tr><td class="etiqueta" >Surcharge:</td>
 <td ><input type="checkbox" name="registro[aplicar_recargo]" value=1 @%db:check_flag{Tipo_cliente.aplicar_recargo}%@
 	>(@%db:si_no_flag{Tipo_cliente.aplicar_recargo};%@)</td>
 </tr>
 </table>
 </form>
 <div class="enviar">
 <a href="#" onClick="return sendForm('modif_tipo_cliente');" >Save</a> 
 <a href="#" onClick="return resetForm('modif_tipo_cliente');" >Undo changes</a> 
 <a href="?seccion=bo_tipo_cliente&estado=2&registro[id_tipo_cliente]=@%db:Tipo_cliente.id_tipo_cliente%@" 
 	onClick="return confirm('Are you sure that do you want to delete the selected registries?');" >Delete</a></div>
