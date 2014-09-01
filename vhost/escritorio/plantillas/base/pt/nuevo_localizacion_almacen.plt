<form name="nuevo_localizacion_articulos" action="?seccion=bo_localizacion_articulos" method=post>
<h3>Novos Campos</h3>
<br>Lote<input type="checkbox" name="registro[lote_propio]" value=1 >
<br>
Piso : <input type="text" name="registro[planta]">
<br>Corredor : <input type="text" name="registro[pasillo]">
<br>Fila : <input type="text" name="registro[fila]">
<br>Coluna : <input type="text" name="registro[columna]">
<br>Quantidade : <input type="text" name="registro[cantidad]">
<br>Data de Validade : <input type="text" name="registro[fecha_caducidad]">
<br>Data de Registo : <input type="text" name="registro[fecha_alta]">
<br>Data da Quebra de Armazém : <input type="text" name="registro[fecha_baja]">
<br>
Produtos: <select name="registro[id_articulo]">

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
Ordens de Fabrico: <select name="registro[lote]">
@%where:tabla|Ordenes_fabricacion;nolink|1;%@
<option value="@%db:Ordenes_fabricacion.lote;%@">
@%db:Ordenes_fabricacion.fecha_caducidad;%@
@%db:Ordenes_fabricacion.observaciones;%@
</option>
 @%end-where:%@

 </select>
<br>
<br>
Zonas Armazém: <select name="registro[id_almacen_logico]">
@%where:tabla|Almacenes_logicos;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@">
@%db:Almacenes_logicos.nombre;%@
</option>
 @%end-where:%@

 </select>
<br>
<a href="javascript:document.forms['nuevo_localizacion_articulos'].submit();">Guardar</a>
<br></form>