<table class="fullstruct contenedor">
<tr class="empresa" ><td class="left" >
@%where:nodb|nodb_reciever_data;%@

<table class="full">
<tr>
<td class="etiqueta" >Nom:</td><td >@%db:razon_social;%@</td>
</tr>

<tr><td class="etiqueta" >Domicile:</td><td >@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta" >Ville:</td><td >@%db:poblacion;%@</td></tr>
<tr><td class="etiqueta" >Province / �tat:</td><td >@%db:provincia;%@</td></tr>
<tr><td class="etiqueta" >CP:</td><td >@%db:cp;%@</td></tr>
<tr><td class="etiqueta" >NSF:</td><td >@%db:prefijo_cif;%@
@%if:!esta_vacio;prefijo_cif;%@
-
@%end-if:%@
@%db:cif;%@</td></tr>
<tr><td class="etiqueta" >T�l�phone:</td><td >@%db:telefono1;%@</td></tr>
<tr><td class="etiqueta" >T�l�copieur:</td><td >@%db:fax;%@</td></tr>
</table>

</td><td class="right">

<table class="full">
<tr><td class="caption" >@%db:razon_social;%@</td></tr>
<tr><td class="tdimgarticulo">
@%set:id_emp=id_empresa%@
@%where:tabla|Empresas;where|id_empresa = $id_emp;nolink|1;%@
<!-- @%db:Empresas.id_empresa%@ -->
<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" height="80" >
@%end-where:%@

</td></tr>
</table>

@%end-where:%@

</td></tr><tr><td class="left">
@%where:nodb|nodb_issuer_data;%@
<table class="full">
<caption >Fournisseur</caption>
<tr><td class="etiqueta">Nom:</td><td>@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">Code:</td><td>@%db:id_cliente;%@</td></tr>
<tr><td class="etiqueta">Domicile:</td><td>@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Ville:</td><td>@%db:poblacion;%@</td></tr>
<tr><td class="etiqueta">Province / �tat:</td><td>@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">CP:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">NSF:</td><td>@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">T�l�phone:</td><td>@%db:telefono1;%@</td></tr>
<tr><td class="etiqueta">T�l�copieur:</td><td>@%db:fax;%@</td></tr>
<tr class="bordes"><td colspan="2" class="codigobarras" >
</td></tr>
</table>
@%end-where:%@

</td><td class="direccionentrega">

@%where:nodb|nodb_reciever_data;%@
<table class="full">
<caption>Direction remise(@%db:direccion_id_direccion;%@)</caption>
<tr><td class="diafano">@%db:direccion_nombre;%@ (T�l- @%db:direccion_telefono1;%@)</td></tr>
<tr><td class="diafano">@%db:direccion_direccion;%@</td></tr>
<tr><td class="diafano">@%db:direccion_codigo_postal;%@ - @%db:direccion_poblacion;%@ @%db:direccion_provincia;%@</td></tr>
<tr><td class="diafano"><!-- @%set:_chop_length=140%@ --> @%db:do_chop{direccion_observaciones};%@</td></tr>
</table>

</td></tr>
</table>
@%end-where:%@

</td></tr>
</table>
