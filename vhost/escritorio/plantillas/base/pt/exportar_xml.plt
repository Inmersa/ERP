<?xml version="1.0" encoding="ISO-8859-15" ?>
<ProductList>
@%where:tabla|Articulos;where|Empresas_articulos.fecha_baja IS NULL;%@
<product id="@%db:Articulos.id_articulo;%@" >
<name>@%db:xml_encode{Articulos.nombre};%@</name>
<reference>@%db:xml_encode{Empresas_articulos.referencia};%@</reference>
<barcode>@%db:Articulos.codigo_barras;%@</barcode>
<description>@%db:xml_encode{Articulos.descripcion};%@</description>
<brand>@%db:xml_encode{Marcas.nombre};%@</brand>
<family>@%db:xml_encode{Familia_articulos.nombre};%@</family>
@%if:existe_imagen_peq;Catalogo_imagenes.nombre;%@
<image type="little" >http://@%env:SERVER_NAME;%@/catalogo/peq_@%db:Catalogo_imagenes.nombre;%@</image>
@%end-if:%@
@%if:existe_imagen_med;Catalogo_imagenes.nombre;%@
<image type="medium" >http://@%env:SERVER_NAME;%@/catalogo/med_@%db:Catalogo_imagenes.nombre;%@</image>
@%end-if:%@
@%if:existe_imagen;Catalogo_imagenes.nombre;%@
<image type="normal" >http://@%env:SERVER_NAME;%@/catalogo/@%db:Catalogo_imagenes.nombre;%@</image>
@%end-if:%@
<date type="entry" >@%db:colocar_fecha{Empresas_articulos.fecha_alta};%@</date>
<date type="lastupdated" >@%db:colocar_fecha{Empresas_articulos.ultima_modificacion};%@</date>
<weightperunit>@%db:Articulos.peso_unidad;%@</weightperunit>
<notes>@%db:xml_encode{Articulos.observaciones};%@</notes>
<stock type="estimated" >@%db:Empresas_articulos.stock_ficticio;%@</stock>
<price1 >@%db:Empresas_articulos.precio_costo;%@</price1>
<price2 >@%db:Empresas_articulos.precio_standard;%@</price2>
<price3 >@%db:Empresas_articulos.precio_venta;%@</price3>
<price4 >@%db:Empresas_articulos.precio_4;%@</price4>
<price5 >@%db:Empresas_articulos.precio_5;%@</price5>
<price6 >@%db:Empresas_articulos.precio_6;%@</price6>
<price6 >@%db:Empresas_articulos.precio_6;%@</price6>
</product>
@%end-where:%@

</ProductList>
