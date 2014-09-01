
@%plt:botonera%@
<table class="full">
<tr>
@%where:nombre|nomberart;tabla|Articulos;nolink|1;where|id_articulo = $id_articulo_promocion;%@
<td class="etiqueta">ID:</td><td>@%db:Articulos.id_articulo;%@</td>
<td class="etiqueta">Nom:</td><td>@%db:Articulos.nombre;%@</td>
@%end-where:%@

<td class="etiqueta">Stock total:</td>
<td>@%func:cantidad_total%@</td>
</tr>
</table>
<table class="full">
<thead>
<tr>
<td >Zone de Magasin </td>
<td >Quantite</td>
<td >Date limite Lot</td>
<td >Début de période</td>
<td >Plante</td>
<td >Couloi</td>
<td >Colonne</td>
<td >Rang</td>
</tr>
</thead>
<tbody>
 @%where:tabla|Localizacion_articulos;nombre|busc;no_results|1;order|Localizacion_articulos.planta,Localizacion_articulos.pasillo,Localizacion_articulos.columna,Localizacion_articulos.fila;%@ 
<tr>
<td><a href="?seccion=bo_inventario_almacen_logico&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@&id_articulo=@%db:Articulos.id_articulo;%@"
	>@%db:Almacenes_logicos.nombre;%@</a></td>
<td>@%db:Localizacion_articulos.cantidad;%@</td>
<td>@%db:colocar_fecha{Localizacion_articulos.fecha_caducidad};%@  
(@%db:Localizacion_articulos.lote%@)</td>
<td>@%db:colocar_fecha{Localizacion_articulos.fecha_alta};%@ </td>
<td>@%db:Localizacion_articulos.planta;%@ </td>
<td>@%db:Localizacion_articulos.pasillo;%@</td>
<td>@%db:Localizacion_articulos.columna;%@</td>
<td>@%db:Localizacion_articulos.fila;%@</td>
 </tr>
 @%end-where:%@

 </tbody>
 </table>
@%plt:botonera%@
