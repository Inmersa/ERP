
<div id="AccionesEncabezado"><ul>
<li><a href="#" onclick="return onHRefClick('bo_importar_articulos','accion_ejecutar','Importar');" class="enviar" 
	><img src="imag/pixel.png" class="icono" /><span>Importer</span></a></li>
<li><a href="#" onclick="return onHRefClick('bo_importar_articulos','accion_ejecutar','Borrar');" class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
</ul></div>

@%plt:botonera%@

<form name="bo_importar_articulos" method="post" action="?seccion=bo_articulos"> 
<input type="hidden" name="accion_ejecutar" value="0" />

<table class="full">
<thead>
<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Marque</td>
<td class="caption">Famille</td>
</tr>
</thead>
<tbody>
@%where:tabla|Articulos;nombre|busc;no_results|1;grupo|Articulos.id_articulo;%@
<tr>
<td class="check"><input type="checkbox" name="insertar_articulo[@%db:Articulos.id_articulo;%@]" value="1" /></td>
<td ><a href="?seccion=modif_articulos&id_articulo=@%db:Articulos.id_articulo;%@">@%db:Articulos.nombre;%@</a></td>
<td >@%db:Marcas.nombre;%@</td>
<td >@%db:Familia_articulos.nombre;%@</td>
</tr>
@%end-where:%@

</tbody>
</table>
</form>

@%plt:botonera%@ 

