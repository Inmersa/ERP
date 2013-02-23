@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Pedido_Proveedor_Datos_Generales" class="fsficha">
<legend>Condiciones del Pedido</legend>

<table class="fullstruct">
<tr>
<td >

<table class="full">
<caption class="titulotb" >Proveedor</caption>
 @%where:nodb|nodb_issuer_data;%@
<tr>
<td class="etiqueta">Proveedor</td>
<td>@%db:razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Domicilio</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">CP</td>
<td>@%db:cp;%@</td>
</tr>
<tr>
<td class="etiqueta">Población</td>
<td>@%db:poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Provincia</td>
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
<caption class="titulotb" >Empresa</caption>
 @%where:nodb|nodb_reciever_data;%@

<tr>
<td class="etiqueta">Código:</td>
<td>@%db:id_cliente;%@</td>
</tr>

<tr>
<td class="etiqueta">Domicilio:</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Población:</td>
<td> @%db:poblacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Provincia:</td>
<td>@%db:provincia;%@</td>
</tr>

<tr>
<td class="etiqueta">CP:</td>
<td>@%db:cp;%@</td>
 </tr>

<tr>
<td class="etiqueta">CIF:</td>
<td>@%db:prefijo_cif;%@-@%db:cif;%@</td>
 </tr>

<tr>
<td class="etiqueta">Teléfono:</td>
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
