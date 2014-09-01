@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Pedido_Proveedor_Datos_Generales" class="fsficha">
<legend>Order Conditions</legend>

<table class="fullstruct">
<tr>
<td >

<table class="full">
<caption class="titulotb" >Supplier</caption>
 @%where:nodb|nodb_issuer_data;%@
<tr>
<td class="etiqueta">Supplier</td>
<td>@%db:razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Address</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Postal Code</td>
<td>@%db:cp;%@</td>
</tr>
<tr>
<td class="etiqueta">City</td>
<td>@%db:poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Area</td>
<td>@%db:provincia;%@</td>
</tr>
<tr>
<td class="etiqueta">Fax</td>
<td>@%db:fax;%@</td>
</tr>
<tr>
<td class="etiqueta">Tel.</td>
<td>@%db:telefono1;%@</td>
</tr>
 @%end-where:%@


</table></td>
<td >
<table class="full">
<caption class="titulotb" >Company</caption>
 @%where:nodb|nodb_reciever_data;%@

<tr>
<td class="etiqueta">Code:</td>
<td>@%db:id_cliente;%@</td>
</tr>

<tr>
<td class="etiqueta">Address:</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>

<tr>
<td class="etiqueta">City:</td>
<td> @%db:poblacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Area:</td>
<td>@%db:provincia;%@</td>
</tr>

<tr>
<td class="etiqueta">Postal Code:</td>
<td>@%db:cp;%@</td>
 </tr>

<tr>
<td class="etiqueta">EIN:</td>
<td>@%db:prefijo_cif;%@-@%db:cif;%@</td>
 </tr>

<tr>
<td class="etiqueta">Telephone:</td>
<td>@%db:telefono1;%@</td>
</tr>

<tr>
<td class="etiqueta">Fax:</td>
<td>@%db:fax;%@</td>
</tr>

<tr>
<td class="etiqueta">e-mail:</td>
<td><a href="mailto:@%db:email;%@">@%db:email;%@</a></td>
</tr>

 @%end-where:%@

</table>
</table>

</fieldset>
