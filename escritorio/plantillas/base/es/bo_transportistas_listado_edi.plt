
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;nuevo_transportistas;%@
<li><a href="?seccion=nuevo_transportistas"  class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nuevo</span></a></li>
@%end-if:%@
<li><a href="return sendForm('modif_transportistas');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Borrar seleccionados</span></a></li>
</ul></div>

<form name="modif_transportistas" action="" method="post">
<input type="hidden" name="estado" value="3" />

<table class="full">
<thead><tr>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td class="caption"><a href="?_search_sort=Transportistas.nombre" class="order" 
	>Nombre<img src="imag/pixel.png" class="@%func:class_searchsort;Transportistas.nombre;%@" /></a></td>
<td class="caption"><a href="?_search_sort=Transportistas.razon_social" class="order" 
	>Razón social<img src="imag/pixel.png" class="@%func:class_searchsort;Transportistas.razon_social;%@" /></a></td>
<td class="caption"><a href="?_search_sort=Transportistas.telefono" class="order" 
	>Teléfono<img src="imag/pixel.png" class="@%func:class_searchsort;Transportistas.telefono;%@" /></a></td>
<td class="caption"><a href="?_search_sort=Transportistas.email" class="order" 
	>e-mail<img src="imag/pixel.png" class="@%func:class_searchsort;Transportistas.email;%@" /></a></td>
</tr></thead>

<tbody>
@%where:tabla|Transportistas;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Transportistas.id_transportista;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_transportistas&id_transportista=@%db:Transportistas.id_transportista;%@">@%db:Transportistas.nombre;%@
</a></td>
<td>@%db:Transportistas.razon_social;%@</td>
<td>@%db:Transportistas.telefono;%@</td>
<td><a href="mailto:@%db:Transportistas.email;%@">@%db:Transportistas.email;%@</a></td>
</tr>
@%end-where:%@

</tr></tbody></table>
</form>

@%plt:botonera%@


