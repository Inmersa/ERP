@%where:tabla|Pedidos;nolink|1;where|id_pedido = $id_pedido;%@
<fieldset id="Albaranes_Pedido_Datosgenerales" class="fsficha">
<legend>Issuer and Receiver information</legend>
 <!-- @%db:Pedidos.id_pedido%@ -->
<table class="full">
<tr>
<td style="vertical-align:top;border:0px;">

<table class="full">
<tr>
<td class="caption" colspan="2">Company</td>
</tr>
<!-- @%db:Pedidos.id_empresa;%@ @%set:id_empresa=Pedidos.id_empresa;%@ -->
@%where:tabla|Empresas;nombre|empresa;nolink|1;where|id_empresa = $id_empresa;%@
<!--
nombre @%db:Empresas.nombre;%@
Convendria colocar estos campos:
prefijo cif @%db:Empresas.prefijo_cif;%@
cif @%db:Empresas.cif;%@
web @%db:Empresas.web;%@
email @%db:Empresas.email;%@
-->
<tr>
<td class="etiqueta">Company</td>
<td>@%db:Empresas.razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Address</td>
<td>@%db:Empresas.direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Postal Code</td>
<td>@%db:Empresas.cp;%@</td>
</tr>
<tr>
<td class="etiqueta">City</td>
<td>@%db:Empresas.poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Area</td>
<td>
@%where:tabla|Provincias;%@
@%db:Provincias.nombre;%@
@%end-where:%@

</td>
</tr>
<tr>
<td class="etiqueta">Fax</td>
<td>@%db:Empresas.fax;%@</td>
</tr>
<tr>
<td class="etiqueta">Tel.</td>
<td>@%db:Empresas.telefono1;%@</td>
</tr>
@%end-where:%@

 </table></td>
<td style="vertical-align:top;border:0px;">
<table class="full">
<!-- @%db:Pedidos.id_direccion%@ @%db:Pedidos.id_proveedor%@
@%set:id_direccion=Pedidos.id_direccion%@ @%set:id_proveedor=Pedidos.id_proveedor%@ -->

@%if:esta_vacio;Pedidos.id_proveedor;%@
 @%where:tabla|Clientes;nolink|1;where|Direcciones_entrega.id_direccion = $id_direccion;%@
<!--
@%db:Direcciones_entrega.id_direccion;%@
nombre @%db:Clientes.nombre;%@
persona contacto @%db:Clientes.persona_contacto;%@
cargo persona contacto @%db:Clientes.cargo_persona_contacto;%@
web @%db:Clientes.web;%@
telefono 2 @%db:Clientes.telefono2;%@
-->
<tr>
<td class="caption" colspan="2">Client</td>
</tr>
<tr>
<td class="etiqueta">Name:</td>
<td>@%db:Clientes.razon_social;%@</td>
</tr>

<tr>
<td class="etiqueta">Code:</td>
<td>@%db:Clientes.id_cliente;%@</td>
</tr>
<tr>
<td class="etiqueta">Address:</td>
<td>@%db:Clientes.direccion_facturacion;%@</td>
</tr>
<tr>
<td class="etiqueta">City:</td>
<td>@%db:Clientes.poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Area:</td>
<td>@%db:Provincias.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Postal Code:</td>
<td>@%db:Clientes.cp;%@</td>
</tr>
<tr>
<td class="etiqueta">EIN:</td>
<td>@%db:Clientes.prefijo_cif;%@-@%db:Clientes.cif;%@</td>
</tr>
<tr>
<td class="etiqueta">Telephone:</td>
<td>@%db:Clientes.telefono1;%@</td>
</tr>
<tr>
<td class="etiqueta">Fax:</td>
<td>@%db:Clientes.fax;%@</td>
</tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td colspan="3"><a href="mailto:@%db:Clientes.email;%@">@%db:Clientes.email;%@</a></td>
</tr>
@%end-where:%@

@%else:%@

 @%where:Tabla|Proveedores;nolink|1;where|id_proveedor = $id_proveedor;%@
<!--
nombre @%db:Proveedores.nombre;%@
persona contacto @%db:Proveedores.persona_contacto;%@
cargo persona contacto @%db:Proveedores.cargo_persona_contacto;%@
web @%db:Proveedores.web;%@
telefono 2 @%db:Proveedores.telefono2;%@
-->
<tr>
<td class="caption" colspan="2">Supplier</td>
<tr>
<td class="etiqueta">Name:</td>
<td>@%db:Proveedores.razon_social;%@</td>
</tr>
<tr>
<td class="etiqueta">Code:</td>
<td>@%db:Proveedores.id_proveedor;%@</td>
</tr>
<tr>
<td class="etiqueta">Address:</td>
<td>@%db:Proveedores.domicilio;%@</td>
</tr>
<tr>
<td class="etiqueta">City:</td>
<td> @%db:Proveedores.poblacion;%@</td>
</tr>
<tr>
<td class="etiqueta">Area:</td>
<td>@%db:Provincias.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta">Postal Code:</td>
<td>@%db:Proveedores.cp;%@</td>
</tr>
<tr>
<td class="etiqueta">EIN:</td>
<td>@%db:Proveedores.prefijo_cif;%@-@%db:Proveedores.cif;%@</td>
</tr>
<tr>
<td class="etiqueta">Telephone:</td>
<td>@%db:Proveedores.telefono1;%@</td>
</tr>
<tr>
<td class="etiqueta">Fax:</td>
<td>@%db:Proveedores.fax;%@</td>
</tr>
<tr>
<td class="etiqueta">e-mail:</td>
<td><a href="mailto:@%db:Proveedores.email;%@">@%db:Proveedores.email;%@</a></td>
</tr>
@%end-where:%@

@%end-if:%@

</table></table>

</fieldset>

