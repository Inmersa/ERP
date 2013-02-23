@%where:nodb|nodb_order_data;nombre|general;%@

<fieldset id="Factura_Proveedor_Datosgenerales" class="fsficha">
<legend>Facture</legend>

<table class="fullstruct">
<tr>
<td>

<table class="full">
<caption class="titulotb">Fournisseur</caption>
 @%where:nodb|nodb_issuer_data;%@
<tr>
<td class="etiqueta">Nom</td>
<td>@%db:razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Domicile</td>
<td>@%db:direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Code</td>
<td>@%db:cp;%@</td>
</tr>
<tr>
<td class="etiqueta">Ville</td>
<td>@%db:poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Province / État</td>
<td>@%db:Provincias.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Télécopieur</td>
<td>@%db:fax;%@</td>
</tr>
<tr>
<td class="etiqueta">Téléphone</td>
<td>@%db:telefono1;%@</td>
</tr>
 @%end-where:%@

 </table>
</td><td>
<table class="full">
<caption class="titulotb">Entreprise</caption>
 @%where:nodb|nodb_reciever_data;%@

<tr><td class="etiqueta">Nom:</td><td colspan="3">@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">Code:</td><td colspan="3">@%db:id_proveedor;%@</td></tr>
<tr><td class="etiqueta">Domicile:</td><td colspan="3">@%db:domicilio;%@</td></tr>
<tr><td class="etiqueta">Ville:</td><td colspan="3"> @%db:poblacion;%@</td></tr>
<tr><td class="etiqueta">Province / État:</td><td>@%db:Provincias.nombre;%@</td><td class="etiqueta">CP:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">NSF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Téléphone:</td><td>@%db:telefono1;%@</td><td class="etiqueta">Télécopieur:</td><td>@%db:fax;%@</td></tr>
<tr><td class="etiqueta">e-mail:</td><td ><a href="mailto:@%db:email;%@">@%db:email;%@</a></td><td class="etiqueta" 
	>Quantité en Compte</td><td >@%db:monto_cuenta;%@</td></tr>
 @%end-where:%@

 </table></td>
</tr>
</table>
</fieldset>
