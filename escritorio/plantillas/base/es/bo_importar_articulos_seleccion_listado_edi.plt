
@%plt:botonera%@

<form name="bo_importar_articulos_seleccion" method="post" action="?seccion=@%get:_krn_old_ss_name;%@">
<input type="hidden" name="accion_ejecutar" value="Importar" />

<table class="full"><thead><tr>
<td class="estado" ><img src="images/pixel.png" class="marcartodos" onclick="return formCheckAll('registro');"  /></td>
<td ><a href="?_search_sort=Articulos.nombre" class="order" >Art�culo<img src="images/pixel.png" class="@%func:class_searchsort;Articulos.nombre;%@" /></a></td>
<td ><a href="?_search_sort=Marcas.nombre"  class="order" >Marca<img src="images/pixel.png" class="@%func:class_searchsort;Marcas.nombre;%@" /></a></td>
<td >Fecha cad.</td>
<td >Lote</td>
<td >Cantidad</td>

<td >Zona</td>

<td >Planta</td>
<td >Pasillo</td>
<td >Colum.</td>
<td >Fila</td>
</tr></thead>

@%if:!esta_vacio;id_almacen_logico_promocion;%@
@%set:_selected_value=id_almacen_logico_promocion;%@
@%end-if:%@
<tbody>
@%where:tabla|Empresas_articulos;nombre|busc;contador|i;no_results|1;%@
<tr
@%if:!esta_vacio;Empresas_articulos.fecha_baja;%@
class="impropio"
@%end-if:%@
>
<td class="check"><input type="checkbox" name="registro[@%db:i;%@][id_articulo]" value="@%db:Empresas_articulos.id_articulo;%@" /></td>
<td><a href="?seccion=modif_articulos&id_articulo=@%db:Empresas_articulos.id_articulo;%@">@%db:Articulos.nombre;%@</a></td>
<td>@%db:Marcas.nombre;%@</td>
<td><input type="text" name="registro[@%db:i;%@][fecha_caducidad]" class="fecha" /></td>
<td><input type="text" name="registro[@%db:i;%@][lote]" class="num" /></td>
<td><input type="text" name="registro[@%db:i;%@][cantidad]" class="num" /></td>
<td>
<select name="registro[@%db:i;%@][id_almacen_logico]">
@%where:tabla|Almacenes_logicos;where|Almacenes_logicos.id_almacen = $id_almacen;nombre|logico;order|Almacenes_logicos.nombre;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@"
@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
>@%db:Almacenes_logicos.nombre;%@</option>
@%end-where:%@ 

</select></td>

<td><input type="text" name="registro[@%db:i;%@][planta]" class="mininum" /></td>
<td><input type="text" name="registro[@%db:i;%@][pasillo]" class="mininum" /></td>
<td><input type="text" name="registro[@%db:i;%@][columna]" class="mininum" /></td>
<td><input type="text" name="registro[@%db:i;%@][fila]" class="mininum" /></td>
 </tr>
@%end-where:%@

</tbody></table>
</form>

@%plt:botonera%@

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return sendForm('bo_importar_articulos_seleccion');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>Modificar</span></a></li>
</ul></div>

