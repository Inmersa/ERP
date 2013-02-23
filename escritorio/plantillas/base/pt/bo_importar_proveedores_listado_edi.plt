
@%plt:botonera%@

<div id="AccionesListado"><ul>
<li><a href="#" onclick="return onHRefClick('bo_proveedores_importar','accion_ejecutar','Importar');" class="enviar" 
	><img src="imag/pixel.png" class="icono" /><span>Recuperar</span></a></li>
<li><a href="#" onclick="return onHRefClick('bo_proveedores_importar','accion_ejecutar','Borrar');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Eliminar</span></a></li>
</ul></div>

<form name="bo_proveedores_importar" method="post" action="?seccion=bo_proveedores" >
<table class="full"><thead><tr>
<td ><a href="?_search_sort=Proveedores.id_proveedor" class="order" 
	>Código<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.id_proveedor;%@" /></a></td>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('proveedor_importar');"  /></td>
<td ><a href="?_search_sort=Proveedores.razon_social" class="order" 
	>Denominação Comercial<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Proveedores.persona_contacto" class="order" 
	>Contacto<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.persona_contacto;%@" /></a></td>
<td ><a href="?_search_sort=Proveedores.cif" class="order" >CIF<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.cif;%@" /></a></td>
</tr></thead>
<tbody>
@%where:tabla|Proveedores;nombre|busc;no_results|1;%@
<tr>
<td><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.id_proveedor;%@</a>
<td class="check"><input type="checkbox" name="proveedor_importar[@%db:Proveedores.id_proveedor;%@]" value="@%db:Proveedores_empresas.id_empresa;%@" /></td>
<td><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.razon_social;%@</a>
 @%db:Proveedores.nombre;%@ @%db:Proveedores.apellidos;%@ 
 @%db:Proveedores.domicilio;%@ - @%db:Proveedores.poblacion;%@
</td>

<td>@%db:Proveedores.persona_contacto;%@ 
<a href="mailto:@%db:Proveedores.email;%@">@%db:Proveedores.email;%@</a>
 @%db:Proveedores.telefono1;%@
</td>
<td >@%db:Proveedores.prefijo_cif;%@ - @%db:Proveedores.cif;%@</td>
</tr>
@%end-where:%@

</tbody></table>
<input type="hidden" name="accion_ejecutar" value="j" />
</form>

 @%plt:botonera%@


