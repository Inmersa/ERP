@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.mostrar_ofertas%@-->
<fieldset class="fsficha">
<legend>Show offer</legend>

<table class="full">
 <tr><td class="etiqueta">Show offer:</td>
 <td> <input type="checkbox" name="registro2[mostrar_ofertas]" value=1 
 	@%db:check_flag{Clientes_empresas.mostrar_ofertas};%@ 
	/> @%db:si_no_flag{Clientes_empresas.mostrar_ofertas};%@</td>
 <td class="etiqueta">Direct Discount:</td>
 <td> <input type="text" name="registro2[dto_directo]" value="@%db:Clientes_empresas.dto_directo;%@" class="insertextnumeros" size="4" />
 % </td>
 </tr>
 <tr> <td class="etiqueta">Apply Volume discount:</td>
 </td>
 <td> <input type="checkbox" name="registro2[aplicar_dto_vol]" value=1 
 	@%db:check_flag{Clientes_empresas.aplicar_dto_vol};%@ 
	/> @%db:si_no_flag{Clientes_empresas.aplicar_dto_vol};%@</td>
 <td class="etiqueta">Prompt payment discount:</td>
 <td> <input type="text" name="registro2[dto_pronto_pago]" value="@%db:Clientes_empresas.dto_pronto_pago;%@" class="insertextnumeros" size="6" maxlength="6" />
 % </td>
 </tr>
</table>
</fieldset>
