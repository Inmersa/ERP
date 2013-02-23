
<form method=post action="?seccion=informe_producto_detallado">
<input type="hidden" name="nom_bus" value="informe_productos_detallado">
<table class="full" >
  <tr> 
  <td class="caption">Relatório Detalhado de Vendas por produto</td>
  <td align="right" class="caption">
        <input type="submit" name=Buscar value="Pesquisar" class="insertext" accesskey="p" >
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
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="4"><input type="text" name="mc_nombre" size="30" class="insertext" value="@%get:st[mc_nombre];%@"></td>
  </tr>
  <tr><td class="titulotb" colspan="11">Totais</td></tr>

  <tr>
  <td class="etiqueta" >Quantidade Requisitada 
  <input type="hidden" name="totales[Marcas.id_marca][Requisitada][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Marcas.id_marca][Requisitada][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Requisitada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Requisitada][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Requisitada][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Requisitada][Média]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Requisitada][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Requisitada][Soma]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Facturada 
  <input type="hidden" name="totales[Marcas.id_marca][Facturada][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Marcas.id_marca][Facturada][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Facturada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturada][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturada][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturada][Média]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Média -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturada][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Facturada][Soma]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Recebida 
  <input type="hidden" name="totales[Marcas.id_marca][Recebida][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Marcas.id_marca][Recebida][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Recebida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recebida][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recebida][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recebida][Média]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recebida][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Recebida][Soma]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Preço De Vendas
  <input type="hidden" name="totales[Marcas.id_marca][Preço][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Marcas.id_marca][Preço][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Preço][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Preço][Máximo]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Preço][Mínimo]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Preço][Média]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Preço][Nº]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Preço][Soma]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Soma
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
  <td class="caption" colspan="10">Família</td></tr>

  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="fm_id" size="30" class="insertext" value="@%get:st[fm_id];%@"></td>
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="4"><input type="text" name="fm_nombre" size="30" class="insertext" value="@%get:st[fm_nombre];%@"></td>
  </tr>

  <tr><td class="titulotb" colspan="11" align="left">Totales</td></tr>

  <tr>
  <td class="etiqueta" >Quantidade Requisitada 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Requisitada][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Requisitada][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Requisitada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Requisitada][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Requisitada][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Requisitada][Média]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Requisitada][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Requisitada][Soma]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Facturada 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Facturada][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Familia_articulos.id_familia][Facturada][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Facturada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturada][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturada][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturada][Média]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Média -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturada][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Facturada][Soma]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Recebida 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Recebida][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Recebida][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Recebida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recebida][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recebida][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recebida][Média]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recebida][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Recebida][Soma]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Preço De Vendas
  <input type="hidden" name="totales[Familia_articulos.id_familia][Preço][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Preço][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Preço][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Preço][Máximo]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Preço][Mínimo]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Preço][Média]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Preço][Nº]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Preço][Soma]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

</table>

<br>
<table class="full">
  <tr><td class="caption" colspan="11">Produtos</td></tr>

  <tr>
  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="ar_id" size="20" class="insertext" value="@%get:st[ar_id];%@"></td>
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="4"><input type="text" name="ar_nombre" size="30" class="insertext" value="@%get:st[ar_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="11">Facturas</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ref. Externa:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Série de Facturação:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">Não Existem Itens Seleccionados</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">De:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">A:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Valor Tributável > :</td>
  <td colspan="2"><input type=text name="fr_basei" size="20" class="insertext" value="@%get:st[fr_basei];%@"></td>
  </tr>

  <tr><td class="titulotb" colspan="11">Ordenação de Resultados</td></tr>
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
  Preço Médio
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
  <td colspan="2" class="titul1al" >Des.</td>
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
  <td class="etiqueta" colspan="2" >Quantidade Requisitada</td>

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
  <td class="titul1al" colspan="2">Des.</td>
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
  <td class="etiqueta" colspan="2">Produto</td>

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
  <td class="titul1al">Des.</td>

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
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="2"><input type="text" name="ag_nombre" size="30" class="insertext" value="@%get:st[ag_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">Não Existem Itens Seleccionados</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Requisitada 
  <input type="hidden" name="totales[Agentes.id_agente][Requisitada][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Agentes.id_agente][Requisitada][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Requisitada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Requisitada][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Requisitada][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Requisitada][Média]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Requisitada][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Requisitada][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Facturada 
  <input type="hidden" name="totales[Agentes.id_agente][Facturada][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Agentes.id_agente][Facturada][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Facturada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturada][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturada][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturada][Média]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Média -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturada][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Facturada][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Recebida 
  <input type="hidden" name="totales[Agentes.id_agente][Recebida][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Agentes.id_agente][Recebida][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Recebida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recebida][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recebida][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recebida][Média]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recebida][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Recebida][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Preço De Vendas
  <input type="hidden" name="totales[Agentes.id_agente][Preço][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Agentes.id_agente][Preço][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Preço][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Preço][Máximo]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Preço][Mínimo]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Preço][Média]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Preço][Nº]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Preço][Soma]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Soma
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
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="2"><input type="text" name="cl_nombre" size="30" class="insertext" value="@%get:st[cl_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Tipo:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">Não Existem Itens Seleccionados</option>
  @%where:tabla|Tipo_cliente;nolink|1;nombre|tiposcl;%@
  <option value="@%db:Tipo_cliente.id_tipo_cliente;%@"
  @%db:selected_value{Tipo_cliente.id_tipo_cliente}%@
  >@%db:Tipo_cliente.nombre;%@</option>
  @%end-where:%@

  </select>
  </td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totais</td></tr>

  <tr>
  <td class="etiqueta" >Quantidade Requisitada 
  <input type="hidden" name="totales[Clientes.id_cliente][Requisitada][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Clientes.id_cliente][Requisitada][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Requisitada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Requisitada][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Requisitada][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Requisitada][Média]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Requisitada][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Requisitada][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Facturada 
  <input type="hidden" name="totales[Clientes.id_cliente][Facturada][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Facturada][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Facturada][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturada][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturada][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturada][Média]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Média -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturada][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Facturada][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantidade Recebida 
  <input type="hidden" name="totales[Clientes.id_cliente][Recebida][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Clientes.id_cliente][Recebida][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Recebida][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recebida][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recebida][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recebida][Média]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recebida][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Recebida][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Preço De Vendas
  <input type="hidden" name="totales[Clientes.id_cliente][Preço][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Clientes.id_cliente][Preço][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Preço][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Preço][Máximo]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Preço][Mínimo]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Preço][Média]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Preço][Nº]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Preço][Soma]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

</table>
<br>
  </form>

