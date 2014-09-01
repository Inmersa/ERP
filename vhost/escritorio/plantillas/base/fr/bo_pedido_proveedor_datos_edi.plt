@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Pedido_Proveedor_Datos_Generales" class="fsficha">
<legend>Conditions de commande</legend>

<table class="fullstruct">
<tr>
<td >

<table class="full">
<caption class="titulotb" >Fournisseur</caption>
 @%where:nodb|nodb_issuer_data;%@
<tr>
<td class="etiqueta">Fournisseur</td>
<td>@%db:razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Domicile</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">CP</td>
<td>@%db:cp;%@</td>
</tr>
<tr>
<td class="etiqueta">Ville</td>
<td>@%db:poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Province / État</td>
<td>@%db:provincia;%@</td>
</tr>
<tr>
<td class="etiqueta">Télécopieur</td>
<td>@%db:fax;%@</td>
</tr>
<tr>
<td class="etiqueta">Tél.</td>
<td>@%db:telefono1;%@</td>
</tr>
 @%end-where:%@


</table></td>
<td >
<table class="full">
<caption class="titulotb" >Entreprise</caption>
 @%where:nodb|nodb_reciever_data;%@

<tr>
<td class="etiqueta">Code:</td>
<td>@%db:id_cliente;%@</td>
</tr>

<tr>
<td class="etiqueta">Domicile:</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Ville:</td>
<td> @%db:poblacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Province / État:</td>
<td>@%db:provincia;%@</td>
</tr>

<tr>
<td class="etiqueta">CP:</td>
<td>@%db:cp;%@</td>
 </tr>

<tr>
<td class="etiqueta">NSF:</td>
<td>@%db:prefijo_cif;%@-@%db:cif;%@</td>
 </tr>

<tr>
<td class="etiqueta">Téléphone:</td>
<td>@%db:telefono1;%@</td>
</tr>

<tr>
<td class="etiqueta">Télécopieur:</td>
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
