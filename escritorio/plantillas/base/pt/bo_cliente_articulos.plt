
<div class="tituloseccion">&gt; Clientes por Produto (
       @%where:tabla|Articulos;nolink|1;where|Articulos.id_articulo = $id_articulo;%@
       @%db:Articulos.nombre;%@
       @%end-where:%@

       )</div>
       
@%plt:Detalles_Descuentos;%@

