@%where:nodb|nodb_order_data;nombre|general;format_name|classDocument;%@
<fieldset id="PedidoEmisorReceptor" class="fsficha">
<legend>Informações de Emissor e de Receptor</legend>

<table class="fullstruct">
<tr>
<td>

<table class="full">
<caption class="titulotb" colspan="4">Emissor</caption>
@%where:nodb|nodb_issuer_data;format_name|Empresas;%@
<tr><td class="etiqueta">Empresa</td><td colspan="3">@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">CIF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Endereço</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Localidade</td><td>@%db:poblacion;%@</td>
<td class="etiqueta">CP</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Distrito</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Tel.</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax</td><td>@%db:fax;%@</td></tr>
@%end-where:%@

</table>

</td><td>

<table class="full">
<caption class="titulotb" colspan="4">Receptor</caption>
 @%where:nodb|nodb_reciever_data;format_name|Clientes;%@
<tr><td class="etiqueta">Cliente:</td>
<td colspan="3">@%db:razon_social;%@ (Código: @%db:id_cliente;%@)</td></tr>
<tr><td class="etiqueta">CIF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Endereço:</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Localidade:</td><td>@%db:poblacion;%@</td><td class="etiqueta">CP:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Distrito:</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Telefone:</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax:</td><td>@%db:fax;%@</td></tr>
<tr><td class="etiqueta">e-mail:</td><td ><a href="mailto:@%db:email;%@">@%db:email;%@</a></td>
<td class="etiqueta" >Quantidade em Conta</td><td >@%db:monto_cuenta;%@</td></tr>
@%end-where:%@

</table>

</td></tr>
</table>

</fieldset>

