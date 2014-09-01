
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;nuevo_series_facturacion;%@
<li><a href="?seccion=nuevo_series_facturacion" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Novo</span></a></li></td>
@%end-if:%@
<li><a href="#" onClick="return sendForm('modif_series_facturacion');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
</ul></div> 

<form name="modif_series_facturacion" action="#" method="post">
<input type="hidden" name="estado" value="3" />
<table class="full">
<thead><tr>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('registro_borrar');"  /></td>
<td ><a href="?_search_sort=Series_facturacion.nombre" class="order" >Nome<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Series_facturacion.descripcion" class="order" >Descrição<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.descripcion;%@" /></a></td>
<td ><a href="?_search_sort=Series_facturacion.contador" class="order" >Contador<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.contador;%@" /></a></td>
<td ><a href="?_search_sort=Series_facturacion.ventas" class="order" >de<img src="imag/pixel.png" 
	class="@%func:class_searchsort;Series_facturacion.ventas;%@" /></a></td>
</tr></thead><tbody>
@%where:tabla|Series_facturacion;nombre|busc;%@
<tr>
<td class="check"> <input type="checkbox" name="registro_borrar[@%db:Series_facturacion.id_serie;%@]" value="1" /></td>
<td class="etiqueta"> <a href="?seccion=modif_series_facturacion&id_serie=@%db:Series_facturacion.id_serie;%@">@%db:Series_facturacion.nombre;%@ </a></td>
<td>@%db:Series_facturacion.descripcion;%@ </td>
<td>@%db:Series_facturacion.contador;%@</td>
<td>
@%if:esta_vacio;Series_facturacion.ventas;%@
De Compras
@%else:%@
De Vendas
@%end-if:%@
</td>
</tr>
@%end-where:%@

</tbody></table>
</form>

@%plt:botonera%@

