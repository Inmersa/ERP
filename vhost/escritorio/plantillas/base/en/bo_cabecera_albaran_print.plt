
<table class="fullstruct contenedor">
<tr class="empresa" >
@%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_cabecera;nolink|1;%@
<td class="left">
<!--@%db:Almacenes.id_almacen%@-->

<table class="full">
@%if:esta_vacio;id_proveedor_cabecera;%@
	<caption>Direction Warehouse of Collection</caption>
@%end-if:%@
	<tr><td class="etiqueta" >Warehouse:</td><td >@%db:Almacenes.nombre;%@</td></tr>

	<tr><td class="etiqueta">Address:</td><td >@%db:Almacenes.direccion;%@</td></tr>
	<tr><td class="etiqueta">City:</td><td >@%db:Almacenes.poblacion;%@</td></tr>

	<tr><td class="etiqueta" >Provinces-States:</td>
	<!-- @%db:Almacenes.id_provincia%@ @%set:id_prov=Almacenes.id_provincia;%@ -->
	 @%where:tabla|Provincias;where|Provincias.id_provincia = $id_prov;nolink|1;%@
	 <td >@%db:Provincias.nombre;%@</td> 
	 @%end-where:%@

	</tr>
	<tr><td class="etiqueta">Postal Code:</td><td >@%db:Almacenes.cp;%@</td></tr>
	<tr><td class="etiqueta">EIN:</td>
	 <td >@%db:Empresas.prefijo_cif;%@
	@%if:!esta_vacio;Empresas.prefijo_cif;%@
	-
	@%end-if:%@
	 @%db:Empresas.cif;%@</td></tr>
	@%if:!esta_vacio;Empresas.capital_social;%@
	<tr><td class="etiqueta">Share capital:</td><td >@%db:Empresas.capital_social;%@</td></tr>
	@%end-if:%@
	@%if:!esta_vacio;Empresas.inscripcion_registro;%@
	<tr><td class="etiqueta">Companies Register:</td><td >@%db:Empresas.inscripcion_registro;%@</td></tr>
	@%end-if:%@

	<tr><td class="etiqueta">Telephone:</td><td >@%db:Almacenes.telefono;%@</td></tr>
	<tr><td class="etiqueta" >Fax:</td><td >@%db:Almacenes.fax;%@</td></tr>
</table>

</td><td class="right">
<table class="full">
	<tr><td class="caption" >@%db:Empresas.razon_social;%@</td></tr>
	<tr><td class="tdimgarticulo" >
	<!--@%db:Empresas.id_imagen;%@-->
	@%if:!esta_vacio;Empresas.id_imagen;%@
	@%where:tabla|Catalogo_imagenes;%@
	<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@" height="80" >
	@%end-where:%@

	@%end-if:%@
	</td></tr>
</table>
</td>
@%end-where:%@

</td></tr><tr ><td class="left">
@%if:esta_vacio;id_proveedor_cabecera;%@
@%where:tabla|Direcciones_entrega;where|Direcciones_entrega.id_direccion = $id_direccion;nolink|1;%@
<!--@%db:Direcciones_entrega.id_direccion%@-->

<table class="full">
	<caption>Client</caption>
	<tr><td class="etiqueta">Name:</td><td >@%db:Clientes.razon_social;%@</td></tr>
	<tr><td class="etiqueta" >Code:</td><td >@%db:Clientes.id_cliente;%@</td></tr>
	<tr><td class="etiqueta" >Address:</td><td >@%db:Clientes.direccion_facturacion;%@</td></tr>
	<tr><td class="etiqueta" >City:</td><td >@%db:Clientes.poblacion;%@</td></tr>
	<tr><td class="etiqueta" >Provinces-States:</td>
	<!-- @%db:Clientes.id_provincia%@ @%set:id_prov=Clientes.id_provincia;%@ -->
	@%where:tabla|Provincias;where|Provincias.id_provincia = $id_prov;nolink|1;%@
	<td >@%db:Provincias.nombre;%@</td> 
	@%end-where:%@

	 <td class="etiqueta" >Postal Code:</td>
	 <td >@%db:Clientes.cp;%@</td>
	</tr>
	<tr>
	 <td class="etiqueta" >EIN:</td>
	 <td >@%db:Clientes.prefijo_cif;%@
	@%if:esta_vacio;Clientes.prefijo_cif;%@
	@%else:%@
	-
	@%end-if:%@
	 @%db:Clientes.cif;%@</td>
	</tr>
	<tr> 
	 <td class="etiqueta" >Telephone:</td><td >@%db:Clientes.telefono1;%@</td>
	 <td class="etiqueta" >Fax:</td><td >@%db:Clientes.fax;%@</td>
	</tr>
</table>
@%if:!esta_vacio;id_albaran;%@
<table class="fullstruct" >
</tr><td class="codigobarras" colspan="4"><img src="modulos/php-barcode/barcode.php?code=A@%get:id_albaran;%@" /></td></tr>
</table>
@%end-if:%@


</td><td class="direccionentrega">

<table class="full">
 <caption>Delivery Add.(@%db:Direcciones_entrega.id_direccion;%@)</caption>
 <tr><td class="diafano">@%db:Direcciones_entrega.nombre;%@(Tel- @%db:Direcciones_entrega.telefono1;%@)</td></tr>
 <tr><td class="diafano">@%db:Direcciones_entrega.direccion;%@</td></tr>
 <tr><td class="diafano">@%db:Direcciones_entrega.cp;%@ - @%db:Direcciones_entrega.poblacion;%@</td></tr>
</table>

</td>
@%end-where:%@

@%else:%@
@%where:tabla|Proveedores;where|Proveedores.id_proveedor = $id_proveedor_cabecera;nolink|1;%@
<!-- @%db:Proveedores.id_proveedor;%@ -->

<table class="full">
	<caption>Supplier</caption>
	<tr><td class="etiqueta">Name:</td><td >@%db:Proveedores.razon_social;%@</td></tr>
	<tr><td class="etiqueta" >Code:</td><td >@%db:Proveedores.id_proveedor;%@</td></tr>
	<tr><td class="etiqueta" >Address:</td><td >@%db:Proveedores.domicilio;%@</td></tr>
	<tr><td class="etiqueta" >City:</td><td >@%db:Proveedores.poblacion;%@</td></tr>
	<tr><td class="etiqueta" >Provinces-States:</td>
	<!-- @%db:Proveedores.id_provincia%@ @%set:id_prov=Proveedores.id_provincia;%@ -->
	@%where:tabla|Provincias;where|Provincias.id_provincia = $id_prov;nolink|1;%@
	<td >@%db:Provincias.nombre;%@</td> 
	@%end-where:%@

	 <td class="etiqueta" >Postal Code:</td>
	 <td >@%db:Proveedores.cp;%@</td>
	</tr>
	<tr>
	 <td class="etiqueta" >EIN:</td>
	 <td >@%db:Proveedores.prefijo_cif;%@
	@%if:!esta_vacio;Proveedores.prefijo_cif;%@
	-
	@%end-if:%@
	 @%db:Proveedores.cif;%@</td>
	</tr>
	<tr> 
	 <td class="etiqueta" >Telephone:</td><td >@%db:Proveedores.telefono1;%@</td>
	 <td class="etiqueta" >Fax:</td><td >@%db:Proveedores.fax;%@</td>
	</tr>
</table>
@%if:!esta_vacio;id_albaran;%@
<table class="fullstruct" >
</tr><td class="codigobarras" colspan="4"><img src="modulos/php-barcode/barcode.php?code=A@%get:id_albaran;%@" /></td></tr>
</table>
@%end-if:%@

</td><td class="direccionentrega">

@%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_cabecera;nolink|1;%@
<table class="full">
 <caption>Delivery Add.(@%db:Almacenes.nombre;%@)</caption>
 <tr><td class="diafano">@%db:Almacenes.persona_contacto;%@(Tel- @%db:Almacenes.telefono;%@)</td></tr>
 <tr><td class="diafano">@%db:Almacenes.direccion;%@</td></tr>
 <tr><td class="diafano">@%db:Almacenes.cp;%@ - @%db:Almacenes.poblacion;%@</td></tr>
</table>
@%end-where:%@

</td>
@%end-where:%@

@%end-if:%@

</tr>
</table>
