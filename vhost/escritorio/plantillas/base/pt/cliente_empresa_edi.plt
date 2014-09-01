@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@

<fieldset class="fsficha">
<legend>Clientes da Empresa</legend>
<input type="hidden" name="registro2[id_cliente]" value="@%db:Clientes_empresas.id_cliente%@" />
<input type="hidden" name="registro2[id_recomendador]" value="@%db:Clientes_empresas.id_recomendador%@" />

 <table class="full">

 <!-- tr><td class="etiqueta" align="right">Pessoa de Contacto:</td>
 <td colspan="3"> <input type="text" name="registro2[persona_contacto]" value="@%db:Clientes_empresas.persona_contacto;%@" class="insertext" size="30" />
 </td>
 </tr>
 <tr> <td class="etiqueta" align="right">Cargo do Contacto:</td>
 <td colspan="3"> <input type="text" name="registro2[cargo_persona_contacto]" value="@%db:Clientes_empresas.cargo_persona_contacto;%@" class="insertext" size="30" />
 </td>
 </tr -->
 
 <tr> <td class="etiqueta">Tarifa:</td>
 <td> <!--@%db:Clientes_empresas.id_tarifa%@ @%set:_selected_value=Clientes_empresas.id_tarifa;%@-->
 <select name="registro2[id_tarifa]" class="insertext">
 @%where:tabla|Tarifas;order|nombre;nolink|1;%@
 <option value="@%db:Tarifas.id_tarifa%@" @%db:selected_value{Tarifas.id_tarifa};%@
>@%db:Tarifas.nombre%@</option>
 @%end-where:%@

 </select>
 </td>
 <td class="etiqueta">Método de Pagamento:</td>
 <td> 
<!--@%db:Clientes_empresas.id_forma_pago%@ @%set:_selected_value=Clientes_empresas.id_forma_pago;%@-->
 <select name="registro2[id_forma_pago]">
 @%where:tabla|Forma_pago;order|nombre;nolink|1;%@
 <option value="@%db:Forma_pago.id_forma_pago%@" 
 @%db:selected_value{Forma_pago.id_forma_pago}%@
>@%db:Forma_pago.nombre%@</option>
 @%end-where:%@

 </select>

 </td>
 </tr>
 <tr>
 <td class="etiqueta" >Importance</td>
 <td> <!--@%db:Clientes_empresas.id_importancia%@ @%set:_selected_value=Clientes_empresas.id_importancia;%@-->
 <select name="registro2[id_importancia]" >
 @%where:tabla|Importancias;order|nivel desc;nolink|1;%@
 <option value="@%db:Importancias.id_importancia%@" 
 @%db:selected_value{Importancias.id_importancia}%@
>@%db:Importancias.nombre%@</option>
 @%end-where:%@

 </select>
 </td>

 <td class="etiqueta">Tipo de Cliente:</td>
 <td> <!--@%db:Clientes_empresas.id_tipo_cliente%@ @%set:_selected_value=Clientes_empresas.id_tipo_cliente;%@-->
 <select name="registro2[id_tipo_cliente]" >
 @%where:tabla|Tipo_cliente;order|nombre;nolink|1;%@
 <option value="@%db:Tipo_cliente.id_tipo_cliente%@" 
 @%db:selected_value{Tipo_cliente.id_tipo_cliente}%@
>@%db:Tipo_cliente.nombre%@</option>
 @%end-where:%@

 </select>
 </td></tr>

 <tr> <td class="etiqueta">Divisa:</td>
 <td>
 <!--@%db:Clientes.id_divisa%@ @%set:_selected_value=Clientes.id_divisa%@ -->
 <select name="registro[id_divisa]" >
 @%where:tabla|Divisa;order|nombre;nolink|1;%@
 <option value="@%db:Divisa.id_divisa%@" 
 @%db:selected_value{Divisa.id_divisa}%@
>@%db:Divisa.nombre%@</option>
 @%end-where:%@

 </select></td>
 <td class="etiqueta" align="right">Dedução:</td>
 <td colspan="3" class="check"><input type="checkbox" name="registro2[aplicar_retencion]" value="1" 
 	@%db:check_flag{Clientes_empresas.aplicar_retencion};%@ />@%db:si_no_flag{Clientes_empresas.aplicar_retencion;%@</td>
 </tr>

 </table>
</fieldset>

<fieldset id="ClienteDiasFacturacion" class="fsficha" >
<legend>Dias do pagamento</legend>
 <table class="full">
 <tr>
 <td class="etiqueta">Primeiro</td>
 <td><input type="text" name="registro2[dia_facturacion_1]" class="insertextnumeros" size="2"
 value="@%db:Clientes_empresas.dia_facturacion_1%@" />
 </td>
 <td class="etiqueta">Segundo</td>
 <td><input type="text" name="registro2[dia_facturacion_2]" class="insertextnumeros" size="2"
 value="@%db:Clientes_empresas.dia_facturacion_2%@" />
</td>
 <td class="etiqueta">Terceiro</td>
 <td><input type="text" name="registro2[dia_facturacion_3]" class="insertextnumeros" size="2"
 value="@%db:Clientes_empresas.dia_facturacion_3%@" />
</td>
 </tr>
</table>
</fieldset>


