
<form method=post action="?seccion=informe_producto_detallado">
<input type="hidden" name="nom_bus" value="informe_productos_detallado">
<table class="full" >
  <tr> 
  <td class="caption">Informe Detallado de Ventas por Producto</td>
  <td align="right" class="caption">
        <input type="submit" name=Buscar value="Buscar" class="insertext" accesskey="b" >
		 <select name="hp">
		@%where:nodb|nodb_hits_page;%@
		<option value="@%db:value;%@"
		@%if:equals;st_hp;value;%@
		selected="selected"
		@%end-if:%@
		>@%db:name;%@</option>
		@%end-where:%@

		</select>
  </td></tr>
</table>
<br>
<table class="full">
  <td align="right" class="check" >
  <input type="checkbox" name="mc_search" value="1"
  @%if:esta_vacio;st[mc_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td align="left" class="caption" colspan="11">Marcas</td>
  </tr>

  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="mc_id" size="30" class="insertext" value="@%get:st[mc_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="4"><input type="text" name="mc_nombre" size="30" class="insertext" value="@%get:st[mc_nombre];%@"></td>
  </tr>
  <tr><td class="titulotb" colspan="11">Totales</td></tr>

  <tr>
  <td class="etiqueta" >Cantidad Pedida 
  <input type="hidden" name="totales[Marcas.id_marca][Pedida][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Marcas.id_marca][Pedida][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Pedida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Pedida][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Pedida][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Pedida][Media]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Pedida][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Pedida][Sumatorio]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Facturada 
  <input type="hidden" name="totales[Marcas.id_marca][Facturado][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Marcas.id_marca][Facturado][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Facturado][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturado][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturado][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturado][Media]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturado][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturado][Sumatorio]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Recibida 
  <input type="hidden" name="totales[Marcas.id_marca][Recibido][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Marcas.id_marca][Recibido][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Recibido][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recibido][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recibido][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recibido][Media]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recibido][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recibido][Sumatorio]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Precio Venta
  <input type="hidden" name="totales[Marcas.id_marca][Precio][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Marcas.id_marca][Precio][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Precio][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Precio][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Precio][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Precio][Media]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Precio][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Precio][Sumatorio]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>
</table>

<br>
<table class="full">
  <td class="check" >
  <input type="checkbox" name="fm_search" value="1"
  @%if:esta_vacio;st[fm_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Familias</td></tr>

  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="fm_id" size="30" class="insertext" value="@%get:st[fm_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="4"><input type="text" name="fm_nombre" size="30" class="insertext" value="@%get:st[fm_nombre];%@"></td>
  </tr>

  <tr><td class="titulotb" colspan="11" align="left">Totales</td></tr>

  <tr>
  <td class="etiqueta" >Cantidad Pedida 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Pedida][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Pedida][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Pedida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Pedida][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Pedida][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Pedida][Media]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Pedida][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Pedida][Sumatorio]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Facturada 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Facturado][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Familia_articulos.id_familia][Facturado][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Facturado][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturado][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturado][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturado][Media]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturado][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturado][Sumatorio]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Recibida 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Recibido][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Recibido][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Recibido][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recibido][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recibido][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recibido][Media]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recibido][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recibido][Sumatorio]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Precio Venta
  <input type="hidden" name="totales[Familia_articulos.id_familia][Precio][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Precio][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Precio][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Precio][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Precio][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Precio][Media]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Precio][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Precio][Sumatorio]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

</table>

<br>
<table class="full">
  <tr><td class="caption" colspan="11">Artículos</td></tr>

  <tr>
  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="ar_id" size="20" class="insertext" value="@%get:st[ar_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="4"><input type="text" name="ar_nombre" size="30" class="insertext" value="@%get:st[ar_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="11">Facturas</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ref. externa:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Serie:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">-- Ninguna seleccion --</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">Desde:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">Hasta:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Base Imp. > :</td>
  <td colspan="2"><input type=text name="fr_basei" size="20" class="insertext" value="@%get:st[fr_basei];%@"></td>
  </tr>

  <tr><td class="titulotb" colspan="11">Ordenar por</td></tr>
  <!-- @%set:_iterate_times=5;%@ -->
  <tr>

  <td class="check" >
  <input type="checkbox" class="insertext" name="orden[precio][accion]" value="1"
  @%if:esta_vacio;orden[precio];%@
  @%else:%@
  checked="checked"
  @%end-if:%@
  >&nbsp;
  <input type="hidden" name="orden[precio][field]" value="precio_medio">
  </td>
  <td class="etiqueta" colspan="2">
  Pr. Medio
  </td><td colspan="2" >
  <!-- @%set:_selected_value=orden[precio_posicion];%@ -->
  <!-- @%set:_iterate_reset=1;%@ -->
  <select class="insertext" name="orden[precio][posicion]">
  @%where:nodb|nodb_iterate;%@
  <option value="@%db:iterate_num;%@"
  @%db:selected_value{iterate_num};%@
  >@%db:iterate_num;%@</option>
  @%end-where:%@

  </select>
  </td>
  <td class="etiqueta" colspan="2" align="right">Asc</td>
  <td class="check" align="right">
  <input type="radio" class="insertext" name="orden[precio][direccion]" value="asc"
  @%if:equals;orden[precio];asc;%@
  checked="checked" 
  @%end-if:%@
  >
  </td><td align="left" class="check">
  <input type="radio" class="insertext" name="orden[precio][direccion]" value="desc"
  @%if:equals;orden[precio];desc;%@
  checked="checked" 
  @%end-if:%@
  >
  </td>
  <td colspan="2" class="titul1al" >Desc</td>
  </tr>

  <tr>
  <td class="check" align="right" >
  <input type="checkbox" class="insertext" name="orden[cantidad][accion]" value="1"
  @%if:esta_vacio;orden[cantidad];%@
  @%else:%@
  checked="checked"
  @%end-if:%@
  >&nbsp;
  <input type="hidden" name="orden[cantidad][field]" value="cantidad_pedida">
  </td>
  <td class="etiqueta" colspan="2" >Cantidad Pedida</td>

  <td colspan="2" >
  <!-- @%set:_selected_value=orden[cantidad_posicion];%@ -->
  <!-- @%set:_iterate_reset=1;%@ -->
  <select class="insertext" name="orden[cantidad][posicion]">
  @%where:nodb|nodb_iterate;%@
  <option value="@%db:iterate_num;%@"
  @%db:selected_value{iterate_num};%@
  >@%db:iterate_num;%@</option>
  @%end-where:%@

  </select>
  <td class="etiqueta" colspan="2" >Asc</td>
  <td class="check">
  <input type="radio" class="insertext" name="orden[cantidad][direccion]" value="asc"
  @%if:equals;orden[cantidad];asc;%@
  checked="checked" 
  @%end-if:%@
  >
  </td><td class="check" align="left">
  <input type="radio" class="insertext" name="orden[cantidad][direccion]" value="desc"
  @%if:equals;orden[cantidad];desc;%@
  checked="checked" 
  @%end-if:%@
  ></td>
  <td class="titul1al" colspan="2">Desc</td>
  </tr>

  <tr>
  <td class="check">
  <input type="checkbox" class="insertext" name="orden[nombre][accion]" value="1"
  @%if:esta_vacio;orden[nombre];%@
  @%else:%@
  checked="checked"
  @%end-if:%@
  ><input type="hidden" name="orden[nombre][field]" value="Articulos.nombre">
  </td>
  <td class="etiqueta" colspan="2">Artículo</td>

  <td colspan="2" >
  <!-- @%set:_selected_value=orden[nombre_posicion];%@ -->
  <!-- @%set:_iterate_reset=1;%@ -->
  <select class="insertext" name="orden[nombre][posicion]">
  @%where:nodb|nodb_iterate;%@
  <option value="@%db:iterate_num;%@"
  @%db:selected_value{iterate_num};%@
  >@%db:iterate_num;%@</option>
  @%end-where:%@

  </select>
  </td>

  <td class="etiqueta" colspan="2" >Asc</td>
  <td class="check" >
  <input type="radio" class="insertext" name="orden[nombre][direccion]" value="asc"
  @%if:equals;orden[nombre];asc;%@
  checked="checked" 
  @%end-if:%@
  >
  </td><td class="check" >
  <input type="radio" class="insertext" name="orden[nombre][direccion]" value="desc"
  @%if:equals;orden[nombre];desc;%@
  checked="checked" 
  @%end-if:%@
  ></td>
  <td class="titul1al">Desc</td>

</table>
<br>
<table class="full">
  <td class="check" >
  <input type="checkbox" name="ag_search" value="1"
  @%if:esta_vacio;st[ag_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Agentes</td>
  </tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="ag_id" size="20" class="insertext" value="@%get:st[ag_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="2"><input type="text" name="ag_nombre" size="30" class="insertext" value="@%get:st[ag_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">-- Ninguna seleccion --</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Pedida 
  <input type="hidden" name="totales[Agentes.id_agente][Pedida][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Agentes.id_agente][Pedida][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Pedida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Pedida][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Pedida][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Pedida][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Pedida][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Pedida][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Facturada 
  <input type="hidden" name="totales[Agentes.id_agente][Facturado][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Agentes.id_agente][Facturado][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Facturado][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturado][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturado][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturado][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturado][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturado][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Recibida 
  <input type="hidden" name="totales[Agentes.id_agente][Recibido][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Agentes.id_agente][Recibido][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Recibido][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recibido][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recibido][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recibido][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recibido][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recibido][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Precio Venta
  <input type="hidden" name="totales[Agentes.id_agente][Precio][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Agentes.id_agente][Precio][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Precio][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Precio][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Precio][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Precio][Media]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Precio][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Precio][Sumatorio]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

</table>

<br>
<table class="full">
  <td class="check" >
  <input type="checkbox" name="cl_search" value="1"
  @%if:esta_vacio;st[cl_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  >
  </td>
  <td class="caption" colspan="10">Clientes</td>
  </tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="cl_id" size="20" class="insertext" value="@%get:st[cl_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="2"><input type="text" name="cl_nombre" size="30" class="insertext" value="@%get:st[cl_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">-- Ninguna seleccion --</option>
  @%where:tabla|Tipo_cliente;nolink|1;nombre|tiposcl;%@
  <option value="@%db:Tipo_cliente.id_tipo_cliente;%@"
  @%db:selected_value{Tipo_cliente.id_tipo_cliente}%@
  >@%db:Tipo_cliente.nombre;%@</option>
  @%end-where:%@

  </select>
  </td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totales</td></tr>

  <tr>
  <td class="etiqueta" >Cantidad Pedida 
  <input type="hidden" name="totales[Clientes.id_cliente][Pedida][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Clientes.id_cliente][Pedida][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Pedida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Pedida][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Pedida][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Pedida][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Pedida][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Pedida][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Facturada 
  <input type="hidden" name="totales[Clientes.id_cliente][Facturado][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Facturado][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Facturado][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturado][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturado][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturado][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Media -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturado][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturado][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Cantidad Recibida 
  <input type="hidden" name="totales[Clientes.id_cliente][Recibido][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Clientes.id_cliente][Recibido][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Recibido][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recibido][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recibido][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recibido][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recibido][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recibido][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Precio Venta
  <input type="hidden" name="totales[Clientes.id_cliente][Precio][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Clientes.id_cliente][Precio][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Precio][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Precio][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Precio][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Precio][Media]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Precio][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Precio][Sumatorio]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

</table>
<br>
  </form>

