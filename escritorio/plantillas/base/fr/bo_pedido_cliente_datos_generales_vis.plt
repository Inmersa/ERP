@%where:nodb|nodb_order_data;nombre|general;%@
<fieldset id="PedidoEmisorReceptor" class="fsficha">
<legend>Information d'emetteur et récepteur</legend>

<table class="full">
<tr>
<td>
<table class="full">
<caption class="titulotb" colspan="4">Emettre</caption>
@%where:nodb|nodb_issuer_data;%@
<tr><td class="etiqueta">Entreprise</td><td colspan="3">@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">NSF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Domicile</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Ville</td><td>@%db:poblacion;%@</td>
<td class="etiqueta">CP</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Province / État</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Tél.</td><td>@%db:telefono1;%@</td><td class="etiqueta">Télécopieur</td><td>@%db:fax;%@</td></tr>
@%end-where:%@


</table>

</td><td>
<table class="full">
<caption class="titulotb" colspan="4">Recevoir</caption>
 @%where:nodb|nodb_reciever_data;%@
<tr><td class="etiqueta">Client:</td>
<td colspan="3">@%db:razon_social;%@ (Code: @%db:id_cliente;%@)</td></tr>
<tr><td class="etiqueta">NSF:</td><td colspan="3">@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Domicile:</td><td colspan="3">@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Ville:</td><td>@%db:poblacion;%@</td><td class="etiqueta">CP:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">Province / État:</td><td colspan="3">@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">Téléphone:</td><td>@%db:telefono1;%@</td><td class="etiqueta">Télécopieur:</td><td>@%db:fax;%@</td></tr>
<tr><td class="etiqueta">e-mail:</td><td colspan="3"><a href="mailto:@%db:email;%@">@%db:email;%@</a></td></tr>
@%end-where:%@

</table>
</td>
</tr>
</table>
</fieldset>

