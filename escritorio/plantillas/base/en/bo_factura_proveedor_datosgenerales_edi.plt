@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Factura_Proveedor_Datosgenerales" class="fsficha">
<legend>INVOICE</legend>

<table class="fullstruct">
<tr>
<td>

<table class="full">
<caption class="titulotb">Supplier</caption>
 @%where:nodb|nodb_issuer_data;%@
<tr>
<td class="etiqueta">Name</td>
<td>@%db:razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Address</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Code</td>
<td>@%db:cp;%@</td>
</tr>
<tr>
<td class="etiqueta">City</td>
<td>@%db:poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Area</td>
<td>@%db:Provincias.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Fax</td>
<td>@%db:fax;%@</td>
</tr>
<tr>
<td class="etiqueta">Telephone</td>
<td>@%db:telefono1;%@</td>
</tr>
 @%end-where:%@

 </table>
</td><td>
<table class="full">
<caption class="titulotb">Company</caption>
 @%where:nodb|nodb_reciever_data;%@

<tr><td class="etiqueta">Name:</td><td colspan="3">@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">Code:</td><td colspan="3">@%db:id_proveedor;%@</td></tr>
<tr><td class="etiqueta">Address:</td><td colspan="3">@%db:domicilio;%@</td></tr>
<tr><td class="etiqueta">City:</td><td colspan="3"> @%db:poblacion;%@</td></tr>
<tr><td class="etiqueta">Area:</td><td>@%db:Provincias.nombre;%@</td><td class="etiqueta">Postal Code:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">EIN:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Telephone:</td><td>@%db:telefono1;%@</td><td class="etiqueta">Fax:</td><td>@%db:fax;%@</td></tr>
<tr><td class="etiqueta">e-mail:</td><td ><a href="mailto:@%db:email;%@">@%db:email;%@</a></td><td class="etiqueta" 
	>Amount in Account</td><td >@%db:monto_cuenta;%@</td></tr>
 @%end-where:%@

 </table></td>
</tr>
</table>
</fieldset>
