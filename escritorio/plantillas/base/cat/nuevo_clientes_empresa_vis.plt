
<fieldset id="NuevoCliente_CLienteEmpresa" class="fsficha">
<legend>Clients Empresa</legend>

 <input type="hidden" name="registro2[id_recomendador]" value="" />
 <table class="full">

 <tr>
 <td class="etiqueta" >Importància</td>
 <td><select name="registro2[id_importancia]" >
 @%where:tabla|Importancias;order|nivel desc;nolink|1;%@
 <option value="@%db:Importancias.id_importancia%@" 
 >@%db:Importancias.nombre%@</option>
 @%end-where:%@

 </select></td>

 <td class="etiqueta">Tipus client:</td>
 <td>
 <select name="registro2[id_tipo_cliente]">
 @%where:tabla|Tipo_cliente;order|nombre;nolink|1;%@
 <option value="@%db:Tipo_cliente.id_tipo_cliente%@">@%db:Tipo_cliente.nombre%@</option>
 @%end-where:%@
 </select></td>
 </tr>

 <tr>
 <td class="etiqueta">Divisa:</td>
 <td><select name="registro[id_divisa]">
 @%where:tabla|Divisa;order|nombre;nolink|1;%@
 <option value="@%db:Divisa.id_divisa%@">@%db:Divisa.nombre%@</option>
@%end-where:%@
 </select></td>

 <td class="etiqueta" align="right">Retenir:</td>
 <td colspan="3" class="check"><input type="checkbox" name="registro2[aplicar_retencion]" value="1" /></td>
 </tr>

 </table>
</fieldset>

