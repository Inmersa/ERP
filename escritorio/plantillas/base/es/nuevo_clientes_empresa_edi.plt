
<fieldset id="NuevoCliente_CLienteEmpresa" class="fsficha">
<legend>Clientes Empresa</legend>

 <input type="hidden" name="registro2[id_recomendador]" value="" />
 <table class="full">
 <tr>
 <td class="etiqueta">Tarifa:</td>
 <td><select name="registro2[id_tarifa]">
 @%where:tabla|Tarifas;order|nombre;nolink|1;%@
 <option value="@%db:Tarifas.id_tarifa%@">@%db:Tarifas.nombre%@</option>
@%end-where:%@

 </select></td>
 <td class="etiqueta">Forma de pago:</td>
 <td>
 <select name="registro2[id_forma_pago]">
 @%where:tabla|Forma_pago;order|nombre;nolink|1;%@
 <option value="@%db:Forma_pago.id_forma_pago%@">@%db:Forma_pago.nombre%@</option>
@%end-where:%@
 </select></td>
 </tr>

 <tr>
 <td class="etiqueta" >Importancia</td>
 <td><select name="registro2[id_importancia]" >
 @%where:tabla|Importancias;order|nivel desc;nolink|1;%@
 <option value="@%db:Importancias.id_importancia%@" 
 >@%db:Importancias.nombre%@</option>
 @%end-where:%@

 </select></td>

 <td class="etiqueta">Tipo cliente:</td>
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

 <td class="etiqueta" align="right">Nos Retiene:</td>
 <td colspan="3" class="check"><input type="checkbox" name="registro2[aplicar_retencion]" value="1" /></td>
 </tr>

 </table>
</fieldset>

