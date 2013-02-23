

@%plt:botonera%@

 <form name="hacer_pedido" method="post" action="?seccion=hacer_pedido">
 <input type="hidden" name="force_" value="1" />
<table class="full">
<thead ><tr>
<td ><a href="?_search_sort=Articulos.nombre" class="order" >Nom<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre" class="order" >Marca<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Empresas_articulos.stock_ficticio" class="order" 
	>Stock E.<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.stock_ficticio;%@" /></a></td>
<td >Paquets</td>
<td >Quantitat</td>
<td ><a href="?_search_sort=Empresas_articulos.unidades_bulto" class="order" 
	>Unitats bo�te<img src="images/pixel.png" class="@%func:class_searchsort;Empresas_articulos.unidades_bulto;%@" /></a></td>
<td >Oferta / Promoci�</td>
</tr></thead>
<tbody>
@%where:tabla|Articulos;nombre|busc;no_results|1;order|Articulos.nombre;contador|count;%@
<input type="hidden" name="seleccion[id_unidad_medida][@%db:count;%@]" value="@%db:Articulos.id_unidad_medida;%@" />
<tr>
<td>@%db:Articulos.nombre;%@ (ID: @%db:Articulos.id_articulo;%@)
@%if:esta_vacio;Empresas_articulos.referencia;%@
@%else:%@
(Ref.: @%db:Empresas_articulos.referencia;%@)
@%end-if:%@
@%if:esta_vacio;Articulos.codigo_barras;%@
@%else:%@
(EAN 13: @%db:Articulos.codigo_barras;%@)
@%end-if:%@
</td>
<td>@%db:Marcas.nombre;%@</td>
<td>@%db:Empresas_articulos.stock_ficticio;%@</td>
<td><input type="hidden" name="array_ids[@%db:count;%@]" value="@%db:Articulos.id_articulo;%@" size="5" />
 <input type="text" name="seleccion[bultos][@%db:count;%@]" value="0" size="5" /></td>
<td><input type="text" name="seleccion[cantidad][@%db:count;%@]" value="0" size="5" /></td>
<td>@%db:Empresas_articulos.unidades_bulto;%@</td>
<td>@%func:descripcion_descuento%@</td>
</tr>
 @%end-where:%@

</tbody></table>
 <input type="hidden" name="Anyadir" value="A�adir" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('hacer_pedido');" class="sumaracesta"><img src="images/pixel.png" class="icono" /><span>Afegir</span></a></li>
</ul></div>

@%plt:botonera%@


