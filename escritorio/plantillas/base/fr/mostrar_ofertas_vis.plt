@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.mostrar_ofertas%@-->
<fieldset class="fsficha">
<legend>Montrer offre</legend>
<input type="hidden" name="registro2[mostrar_ofertas]" value="1" /> 
<input type="hidden" name="registro2[aplicar_dto_vol]" value="1" />

<table class="full">
 <tr><td class="etiqueta">Remise direct:</td>
 <td>@%db:Clientes_empresas.dto_directo;%@ % </td>
 <td class="etiqueta">Remise prompt paiment:</td>
 <td> @%db:Clientes_empresas.dto_pronto_pago;%@ %</td></tr>

 <tr><td class="etiqueta">Remises par volume:</td>
 <td colspan="3"> @%db:si_no_flag{Clientes_empresas.aplicar_dto_vol};%@</td></tr>
</table>
</fieldset>
