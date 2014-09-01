@%where:tabla|Clientes_empresas;where|Clientes_empresas.id_empresa = $id_empresa and Clientes_empresas.id_cliente= $id_cliente_promocion;%@
<!--@%db:Clientes_empresas.mostrar_ofertas%@-->
<fieldset class="fsficha">
<legend>Mostrar Oferta</legend>
<input type="hidden" name="registro2[mostrar_ofertas]" value="1" /> 
<input type="hidden" name="registro2[aplicar_dto_vol]" value="1" />

<table class="full">
 <tr><td class="etiqueta">Desconto Directo:</td>
 <td>@%db:Clientes_empresas.dto_directo;%@ % </td>
 <td class="etiqueta">Desconto de Pronto Pagamento:</td>
 <td> @%db:Clientes_empresas.dto_pronto_pago;%@ %</td></tr>

 <tr><td class="etiqueta">Aplicar Desconto por Volume:</td>
 <td colspan="3"> @%db:si_no_flag{Clientes_empresas.aplicar_dto_vol};%@</td></tr>
</table>
</fieldset>
