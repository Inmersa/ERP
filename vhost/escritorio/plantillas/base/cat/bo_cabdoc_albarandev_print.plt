
<table class="fullstruct contenedor">
<tr class="empresa" >
@%where:tabla|Almacenes;where|Almacenes.id_almacen = $id_almacen_cabecera;nolink|1;%@
<td class="left">
<!--@%db:Almacenes.id_almacen%@-->

<table class="full">
	<tr><td class="etiqueta" >Magatzem:</td><td >@%db:Almacenes.nombre;%@</td></tr>

	<tr><td class="etiqueta">Domicili:</td><td >@%db:Almacenes.direccion;%@</td></tr>
	<tr><td class="etiqueta">Població:</td><td >@%db:Almacenes.poblacion;%@</td></tr>

	<tr><td class="etiqueta" >Províncies:</td>
	<!-- @%db:Almacenes.id_provincia%@ @%set:id_prov=Almacenes.id_provincia;%@ -->
	 @%where:tabla|Provincias;where|Provincias.id_provincia = $id_prov;nolink|1;%@
	 <td >@%db:Provincias.nombre;%@</td> 
	 @%end-where:%@

	</tr>
	<tr><td class="etiqueta">CP:</td><td >@%db:Almacenes.cp;%@</td></tr>
	<tr><td class="etiqueta">CIF:</td>
	 <td >@%db:Empresas.prefijo_cif;%@
	@%if:!esta_vacio;Empresas.prefijo_cif;%@
	-
	@%end-if:%@
	 @%db:Empresas.cif;%@</td></tr>
	@%if:!esta_vacio;Empresas.capital_social;%@
	<tr><td class="etiqueta">Capital Social:</td><td >@%db:Empresas.capital_social;%@</td></tr>
	@%end-if:%@
	@%if:!esta_vacio;Empresas.inscripcion_registro;%@
	<tr><td class="etiqueta">Registre Mercantil:</td><td >@%db:Empresas.inscripcion_registro;%@</td></tr>
	@%end-if:%@

	<tr><td class="etiqueta">Telèfon:</td><td >@%db:Almacenes.telefono;%@</td></tr>
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
@%if:esta_vacio;id_proveedor_cabecera;%@
	<caption>Adreça Magatzem de Recollida (@%db:Direcciones_entrega.nombre;%@)</caption>
@%end-if:%@

	<tr><td class="etiqueta">Nom:</td><td >@%db:Clientes.razon_social;%@ (@%db:Clientes.id_cliente;%@)</td></tr>
	<tr><td class="etiqueta" >CIF:</td>
	 <td >@%db:Clientes.prefijo_cif;%@
	@%if:!esta_vacio;Clientes.prefijo_cif;%@
	- 
	@%end-if:%@
	@%db:Clientes.cif;%@
	</td></tr>

	<tr><td class="etiqueta" >Codi:</td><td >@%db:Direcciones_entrega.id_direccion;%@</td></tr>
	<tr><td class="etiqueta" >Domicili:</td><td >@%db:Direcciones_entrega.direccion;%@</td></tr>
	<tr><td class="etiqueta" >Població:</td><td >@%db:Direcciones_entrega.poblacion;%@</td></tr>
	<tr><td class="etiqueta" >Províncies:</td>
	<!-- @%db:Direcciones_entrega.id_provincia%@ @%set:id_prov=Direcciones_entrega.id_provincia;%@ -->
	@%where:tabla|Provincias;where|Provincias.id_provincia = $id_prov;nolink|1;%@
	<td >@%db:Provincias.nombre;%@</td> 
	@%end-where:%@

	 <td class="etiqueta" >CP:</td>
	 <td >@%db:Direcciones_entrega.cp;%@</td>
	</tr>
	<tr> 
	 <td class="etiqueta" >Telèfon:</td><td >@%db:Direcciones_entrega.telefono1;%@</td>
	 <td class="etiqueta" >Fax:</td><td >@%db:Direcciones_entrega.fax;%@</td>
	</tr>
</table>
@%end-where:%@

</td><td class="direccionentrega">
<table class="full">
 <caption>Adreça entrega</caption>
 <tr><td class="diafano">@%db:Almacenes.nombre;%@(Tel- @%db:Almacenes.telefono;%@)</td></tr>
 <tr><td class="diafano">@%db:Almacenes.direccion;%@</td></tr>
 <tr><td class="diafano">@%db:Almacenes.cp;%@ - @%db:Almacenes.poblacion;%@</td></tr>
</table>

</td>

@%else:%@

<table class="full">
	<caption>Adreça Magatzem de Recollida (@%db:Almacenes.nombre;%@)</caption>
	<tr><td class="etiqueta" >Domicili:</td><td >@%db:Almacenes.direccion;%@</td></tr>
	<tr><td class="etiqueta" >Població:</td><td >@%db:Almacenes.poblacion;%@</td></tr>
	<tr><td class="etiqueta" >Províncies:</td>
	<!-- @%db:Almacenes.id_provincia%@ @%set:id_prov=Almacenes.id_provincia;%@ -->
	@%where:tabla|Provincias;where|Provincias.id_provincia = $id_prov;nolink|1;%@
	<td >@%db:Provincias.nombre;%@</td> 
	@%end-where:%@

	 <td class="etiqueta" >CP:</td><td >@%db:Almacenes.cp;%@</td>
	</tr>
	<tr> 
	 <td class="etiqueta" >Telèfon:</td><td >@%db:Almacenes.telefono;%@</td>
	 <td class="etiqueta" >Fax:</td><td >@%db:Almacenes.fax;%@</td>
	</tr>
</table>

</td><td class="direccionentrega">
@%where:tabla|Proveedores;where|Proveedores.id_proveedor = $id_proveedor_cabecera;nolink|1;%@
<!-- @%db:Proveedores.id_proveedor;%@ -->
<table class="full">
 <caption>Adreça entrega(@%db:Proveedores.prefijo_cif;%@@%db:Proveedores.cif;%@)</caption>
 <tr><td class="diafano">@%db:Proveedores.razon_social;%@(Tel- @%db:Proveedores.telefono1;%@)</td></tr>
 <tr><td class="diafano">@%db:Proveedores.domicilio;%@</td></tr>
 <tr><td class="diafano">@%db:Proveedores.cp;%@ - @%db:Proveedores.poblacion;%@
	<!-- @%db:Proveedores.id_provincia%@ @%set:id_prov=Proveedores.id_provincia;%@ -->
	@%where:tabla|Provincias;where|Provincias.id_provincia = $id_prov;nolink|1;%@
	(@%db:Provincias.nombre;%@)
	@%end-where:%@

 </td></tr>
</table>
</td>
@%end-where:%@

</tr>
</table>
