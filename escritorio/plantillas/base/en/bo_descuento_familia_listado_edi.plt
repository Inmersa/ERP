
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;nuevo_descuento_familia;%@
<li><a href="?seccion=nuevo_descuento_familia" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
@%end-if:%@
<li><a href="return sendForm('modif_descuento_familia');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>


<form name="modif_descuento_familia" action="" method="post">
<input type="hidden" name="estado" value="3" />

<table class="full">
<thead><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Familia_articulos.nombre" class="order" 
	>Family Name<img src="images/pixel.png" class="@%func:class_searchsort;Familia_articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Descuento_familia.descuento" class="order" 
	>Discount<img src="images/pixel.png" class="@%func:class_searchsort;Descuento_familia.descuento;%@" /></a></td>
</tr>
</thead>
<tbody>
 @%where:tabla|Descuento_familia;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Descuento_familia.id_familia;%@]"value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_descuento_familia&id_familia=@%db:Descuento_familia.id_familia;%@">@%db:Familia_articulos.nombre;%@</a></td>
<td>@%db:Descuento_familia.descuento;%@ %</td>
 </tr>
 @%end-where:%@

</tbod/></table>
</form>

@%plt:botonera%@


