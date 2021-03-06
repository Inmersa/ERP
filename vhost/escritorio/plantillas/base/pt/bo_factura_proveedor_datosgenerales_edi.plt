@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Factura_Proveedor_Datosgenerales" class="fsficha">
<legend>Factura</legend>

<table class="fullstruct">
<tr>
<td>

<table class="full">
<caption class="titulotb">Fornecedor</caption>
 @%where:nodb|nodb_issuer_data;%@
<tr>
<td class="etiqueta">Nome</td>
<td>@%db:razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Endere�o</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">C�digo</td>
<td>@%db:cp;%@</td>
</tr>
<tr>
<td class="etiqueta">Localidade</td>
<td>@%db:poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Distrito</td>
<td>@%db:Provincias.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Fax</td>
<td>@%db:fax;%@</td>
</tr>
<tr>
<td class="etiqueta">Telefone</td>
<td>@%db:telefono1;%@</td>
</tr>
 @%end-where:%@

 </table>
</td><td>
<table class="full">
<caption class="titulotb">Empresa</caption>
 @%where:nodb|nodb_reciever_data;%@

<tr><td class="etiqueta">Nome:</td><td colspan="3">@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">C�digo:</td><td colspan="3">@%db:id_proveedor;%@</td></tr>
<tr><td class="etiqueta">Endere�o:</td><td colspan="3">@%db:domicilio;%@</td></tr>
<tr><td class="etiqueta">Localidade:</td><td colspan="3"> @%db:poblacion;%@</td></tr>
<tr><td class="etiqueta">Distrito:</td><td>@%db:Provincias.nombre;%@</td><td class="etiqueta">CP:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">CIF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Telefone:</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax:</td><td>@%db:fax;%@</td></tr>
<tr><td class="etiqueta">e-mail:</td><td ><a href="mailto:@%db:email;%@">@%db:email;%@</a></td><td class="etiqueta" 
	>Quantidade em Conta</td><td >@%db:monto_cuenta;%@</td></tr>
 @%end-where:%@

 </table></td>
</tr>
</table>
</fieldset>
