@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Pedido_Proveedor_Datos_Generales" class="fsficha">
<legend>Condicions de comanda</legend>

<table class="fullstruct">
<tr>
<td >

<table class="full">
<caption class="titulotb" >Proveïdor</caption>
 @%where:nodb|nodb_issuer_data;%@
<tr>
<td class="etiqueta">Proveïdor</td>
<td>@%db:razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Domicili</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">CP</td>
<td>@%db:cp;%@</td>
</tr>
<tr>
<td class="etiqueta">Població</td>
<td>@%db:poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Província</td>
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
<td class="etiqueta">Codi:</td>
<td>@%db:id_cliente;%@</td>
</tr>

<tr>
<td class="etiqueta">Domicili:</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Població:</td>
<td> @%db:poblacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Província:</td>
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
<td class="etiqueta">Telèfon:</td>
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
