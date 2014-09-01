@%where:nodb|nodb_order_data;nombre|general;%@
<fieldset id="PedidoEmisorReceptor" class="fsficha">
<legend>Informacion de Emisor y Receptor</legend>

<table class="full">
<tr>
<td>
<table class="full">
<caption class="titulotb" colspan="4">Emisor</caption>
@%where:nodb|nodb_issuer_data;%@
<tr><td class="etiqueta">Empresa</td><td colspan="3">@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">CIF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Domicilio</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Población</td><td>@%db:poblacion;%@</td>
<td class="etiqueta">CP</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Provincia</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Tel.</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax</td><td>@%db:fax;%@</td></tr>
@%end-where:%@


</table>

</td><td>
<table class="full">
<caption class="titulotb" colspan="4">Receptor</caption>
 @%where:nodb|nodb_reciever_data;%@
<tr><td class="etiqueta">Cliente:</td>
<td colspan="3">@%db:razon_social;%@ (Código: @%db:id_cliente;%@)</td></tr>
<tr><td class="etiqueta">CIF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Domicilio:</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Población:</td><td>@%db:poblacion;%@</td><td class="etiqueta">CP:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Provincia:</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Teléfono:</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax:</td><td>@%db:fax;%@</td></tr>
<tr><td class="etiqueta">e-mail:</td><td colspan="3"><a href="mailto:@%db:email;%@">@%db:email;%@</a></td></tr>
@%end-where:%@

</table>
</td>
</tr>
</table>
</fieldset>

