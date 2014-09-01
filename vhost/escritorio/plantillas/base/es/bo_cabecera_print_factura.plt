@%where:nodb|nodb_order_data;%@
<table class="fullstruct contenedor">
<tr class="empresa" ><td class="left">

@%if:!esta_vacio;id_serie_contabilizable;%@

@%where:nodb|nodb_issuer_data;%@

<table class="full">
<tr><td class="etiqueta" >Nombre:</td><td >@%db:razon_social;%@</td></tr>
@%if:!esta_vacio;capital_social;%@
<tr><td class="etiqueta" >Capital Social:</td><td >@%db:capital_social;%@ 
@%where:nodb|nodb_currency_data;%@
@%db:leyenda;%@
@%end-where:%@

</td></tr>
@%end-if:%@
@%if:!esta_vacio;inscripcion_registro;%@
<tr><td class="etiqueta" >Registro Mercantil:</td><td >@%db:inscripcion_registro;%@</td></tr>
@%end-if:%@

<tr><td class="etiqueta" >Domicilio:</td><td >@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta" >Población:</td><td >@%db:poblacion;%@</td></tr>
<tr><td class="etiqueta" >Provincia:</td><td >@%db:provincia;%@</td></tr>
<tr><td class="etiqueta" >CP:</td><td >@%db:cp;%@</td></tr>
<tr><td class="etiqueta" >CIF:</td><td >@%db:prefijo_cif;%@
@%if:!esta_vacio;prefijo_cif;%@
-
@%end-if:%@
@%db:cif;%@</td></tr>
<tr><td class="etiqueta" >Telefono:</td><td >@%db:telefono1;%@</td></tr>
<tr><td class="etiqueta" >Fax:</td><td >@%db:fax;%@</td></tr>
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

@%end-if:%@
</td></tr>
<tr><td class="left">

@%where:nodb|nodb_reciever_data;%@
<table class="full">
<caption >Cliente</caption>
<tr><td class="etiqueta">Nombre:</td><td>@%db:razon_social;%@</td></tr>
<tr><td class="etiqueta">Código:</td><td>@%db:id_cliente;%@</td></tr>
<tr><td class="etiqueta">Domicilio:</td><td>@%db:direccion_facturacion;%@</td></tr>
<tr><td class="etiqueta">Población:</td><td>@%db:poblacion;%@</td></tr>
<tr><td class="etiqueta">Provincia:</td><td>@%db:provincia;%@</td></tr>
<tr><td class="etiqueta">CP:</td><td>@%db:cp;%@</td></tr>
<tr><td class="etiqueta">CIF:</td><td>@%db:prefijo_cif;%@-@%db:cif;%@</td></tr>
<tr><td class="etiqueta">Telefono:</td><td>@%db:telefono1;%@</td></tr>
<tr><td class="etiqueta">Fax:</td><td>@%db:fax;%@</td></tr>
<tr class="bordes"><td colspan="2" class="codigobarras" >
</td></tr>
</table>

</td><td class="direccionentrega">

@%where:nodb|nodb_invoice_deliveredto;%@
<table class="full">
<tr><td class="diafano">@%db:nombre;%@ (@%db:persona_contacto%@ Tel.:@%db:telefono1;%@)</td></tr>
<tr><td class="diafano">@%db:direccion;%@</td></tr>
<tr><td class="diafano">@%db:cp;%@ - @%db:poblacion;%@ @%db:provincia;%@</td></tr>
<tr><td class="diafano">@%db:observaciones;%@</td></tr>
</table>
@%end-where:%@

</td></tr>
</table>
@%end-where:%@

</td></tr></table>

