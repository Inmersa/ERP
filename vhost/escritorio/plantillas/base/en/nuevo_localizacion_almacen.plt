<form name="nuevo_localizacion_articulos" action="?seccion=bo_localizacion_articulos" method=post>
<h3>New fields</h3>
<br>Lot<input type="checkbox" name="registro[lote_propio]" value=1 >
<br>
Floor : <input type="text" name="registro[planta]">
<br>Corridor : <input type="text" name="registro[pasillo]">
<br>Row : <input type="text" name="registro[fila]">
<br>Column : <input type="text" name="registro[columna]">
<br>Amount : <input type="text" name="registro[cantidad]">
<br>Use-by date : <input type="text" name="registro[fecha_caducidad]">
<br>Register date : <input type="text" name="registro[fecha_alta]">
<br>Sack date : <input type="text" name="registro[fecha_baja]">
<br>
Articles: <select name="registro[id_articulo]">

@%where:tabla|Empresas_articulos;where|Empresas_articulos.id_empresa = $id_empresa;%@
<option value="@%db:Empresas_articulos.id_articulo;%@">
@%db:Articulos.nombre;%@
@%db:Articulos.descripcion;%@
@%db:Articulos.observaciones;%@
@%db:Articulos.codigo_barras;%@
</option>

 @%end-where:%@

 </select>
<br>
<br>
Manufacture orders: <select name="registro[lote]">
@%where:tabla|Ordenes_fabricacion;nolink|1;%@
<option value="@%db:Ordenes_fabricacion.lote;%@">
@%db:Ordenes_fabricacion.fecha_caducidad;%@
@%db:Ordenes_fabricacion.observaciones;%@
</option>
 @%end-where:%@

 </select>
<br>
<br>
Warehouse Zones: <select name="registro[id_almacen_logico]">
@%where:tabla|Almacenes_logicos;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@">
@%db:Almacenes_logicos.nombre;%@
</option>
 @%end-where:%@

 </select>
<br>
<a href="javascript:document.forms['nuevo_localizacion_articulos'].submit();">Save</a>
<br></form>