@%where:nodb|nodb_order_data;nombre|general;format_name|classDocument;%@
<fieldset id="PedidoEmisorReceptor" class="fsficha">
<legend>Issuer and Receiver information</legend>

<table class="fullstruct">
<tr>
<td>

<table class="full">
<caption class="titulotb" colspan="4">Issuer</caption>
@%where:nodb|nodb_issuer_data;format_name|Empresas;%@
<tr><td class="etiqueta">Company</td><td colspan="3">@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">EIN:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Address</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">City</td><td>@%db:poblacion;%@</td>
<td class="etiqueta">Postal Code</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Area</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Tel.</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax</td><td>@%db:fax;%@</td></tr>
@%end-where:%@

</table>

</td><td>

<table class="full">
<caption class="titulotb" colspan="4">Receiver</caption>
 @%where:nodb|nodb_reciever_data;format_name|Clientes;%@
<tr><td class="etiqueta">Client:</td>
<td colspan="3">@%db:razon_social;%@ (Code: @%db:id_cliente;%@)</td></tr>
<tr><td class="etiqueta">EIN:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Address:</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">City:</td><td>@%db:poblacion;%@</td><td class="etiqueta">Postal Code:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Area:</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Telephone:</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax:</td><td>@%db:fax;%@</td></tr>
<tr><td class="etiqueta">e-mail:</td><td ><a href="mailto:@%db:email;%@">@%db:email;%@</a></td>
<td class="etiqueta" >Amount in Account</td><td >@%db:monto_cuenta;%@</td></tr>
@%end-where:%@

</table>

</td></tr>
</table>

</fieldset>

