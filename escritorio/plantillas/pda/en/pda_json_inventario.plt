

@%where:tabla|Localizacion_articulos;where|Articulos.codigo_barras='$codigo_barras' OR Articulos.codigo_barras_bulto='$codigo_barras' OR Articulos.codigo_barras_palet='$codigo_barras';contador|i;%@
<!-- @%db:Localizacion_articulos.id_articulo;%@ -->
@%if:equals;i;1;%@
@%db:Articulos.nombre;%@ 
@%db:Articulos.id_articulo;%@
@%db:Marcas.nombre;%@
@%end-if:%@

@%db:Localizacion_articulos.id_almacen_logico;%@ - 
	@%db:Localizacion_articulos.planta;%@:@%db:Localizacion_articulos.pasillo;%@:@%db:Localizacion_articulos.columna;%@:@%db:Localizacion_articulos.fila;%@

	@%db:Localizacion_articulos.fecha_caducidad;fmtas|Detalles_albaran.fecha_caducidad;%@
	* @%db:Localizacion_articulos.lote;%@

	@%db:Localizacion_articulos.cantidad;%@  

@%end-where:%@

