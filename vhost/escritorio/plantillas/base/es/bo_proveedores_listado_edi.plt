
 @%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;nuevo_proveedores;%@
 <li><a href="?seccion=nuevo_proveedores" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nuevo proveedor</span></a></li>
@%end-if:%@
@%if:AllowedLink;bo_importar_proveedores;%@
<li><a href="?seccion=bo_importar_proveedores" class="importarusuario" ><img src="imag/pixel.png" class="icono" /><span>Importar proveedor</span></a></li>
@%end-if:%@
<li><a href="#" onclick="return sendForm('bo_proveedores');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
</ul></div>

<form name="bo_proveedores" method="post" action="?seccion=@%get:_krn_ss_name;%@" >
<input type="hidden" name="accion_ejecutar" value="Borrar" />

<table class="full">
<thead><tr>
<td ><a href="?_search_sort=Proveedores.id_proveedor" class="order" 
	>Código<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.id_proveedor;%@" /></a></td>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('proveedor_borrar');"  /></td>
<td ><a href="?_search_sort=Proveedores.razon_social" class="order" 
	>Razón social<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.razon_social;%@" /></a></td>
<td ><a href="?_search_sort=Proveedores.persona_contacto" class="order" 
	>Contacto<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.persona_contacto;%@" /></a></td>
<td ><a href="?_search_sort=Proveedores.cif" class="order" >CIF<img src="imag/pixel.png" class="@%func:class_searchsort;Proveedores.cif;%@" /></a></td>
</tr></thead>

<tbody>
 @%where:tabla|Proveedores;nombre|busc;no_results|1;%@
<tr>
<td>@%db:Proveedores.id_proveedor;%@</td>
<td class="check"><input type="checkbox" name="proveedor_borrar[@%db:Proveedores.id_proveedor;%@]" value="1" />
</td>
<td><a href="?seccion=modif_proveedores&id_proveedor=@%db:Proveedores.id_proveedor;%@">@%db:Proveedores.nombre;%@</a>
 @%db:Proveedores.razon_social;%@
 @%db:Proveedores.domicilio;%@ - @%db:Proveedores.poblacion;%@
</td>
<td>@%db:Proveedores.persona_contacto;%@
<a href="mailto:@%db:Proveedores.email;%@">@%db:Proveedores.email;%@</a>
 @%db:Proveedores.telefono1;%@
</td>
<td>@%db:Proveedores.prefijo_cif;%@ - @%db:Proveedores.cif;%@</td>
</tr>
 @%end-where:%@
 
</tbody></table>
</form>

@%plt:botonera%@ 


