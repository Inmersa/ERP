
<form method=post action="?seccion=informe_producto_detallado">
<input type="hidden" name="nom_bus" value="informe_productos_detallado">
<table class="full" >
  <tr> 
  <td class="caption">Rapport D�taill� de Ventes par produit</td>
  <td align="right" class="caption">
        <input type="submit" name=Buscar value="Chercher" class="insertext" accesskey="r" >
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
  <td align="left" class="caption" colspan="11">Marques</td>
  </tr>

  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="mc_id" size="30" class="insertext" value="@%get:st[mc_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="4"><input type="text" name="mc_nombre" size="30" class="insertext" value="@%get:st[mc_nombre];%@"></td>
  </tr>
  <tr><td class="titulotb" colspan="11">Totals</td></tr>

  <tr>
  <td class="etiqueta" >Quantit� Demand�e 
  <input type="hidden" name="totales[Marcas.id_marca][Demand�e][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Marcas.id_marca][Demand�e][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Demand�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Demand�e][Maximum]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Demand�e][Minimum]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Demand�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Demand�e][N�]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Demand�e][Sommation]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Factur�e 
  <input type="hidden" name="totales[Marcas.id_marca][Factur�e][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Marcas.id_marca][Factur�e][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Factur�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Factur�e][Maximum]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Factur�e][Minimum]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Factur�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Factur�e][N�]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Factur�e][Sommation]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Re�ue 
  <input type="hidden" name="totales[Marcas.id_marca][Re�ue][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Marcas.id_marca][Re�ue][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Re�ue][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Re�ue][Maximum]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Re�ue][Minimum]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Re�ue][Moyenne]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Re�ue][N�]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Re�ue][Sommation]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Prix de Ventes
  <input type="hidden" name="totales[Marcas.id_marca][Prix][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Marcas.id_marca][Prix][round]" value="2">
  <!-- input type="hidden" name="totales[Marcas.id_marca][Prix][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Prix][Maximum]" value="max"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Prix][Minimum]" value="min"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Prix][Moyenne]" value="avg"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Prix][N�]" value="count"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Marcas.id_marca][Prix][Sommation]" value="sum"
  @%func:checkbox_mark;Marcas.id_marca;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Sommation
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
  <td class="caption" colspan="10">Familles</td></tr>

  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="fm_id" size="30" class="insertext" value="@%get:st[fm_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="4"><input type="text" name="fm_nombre" size="30" class="insertext" value="@%get:st[fm_nombre];%@"></td>
  </tr>

  <tr><td class="titulotb" colspan="11" align="left">Totales</td></tr>

  <tr>
  <td class="etiqueta" >Quantit� Demand�e 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Demand�e][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Demand�e][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Demand�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Demand�e][Maximum]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Demand�e][Minimum]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Demand�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Demand�e][N�]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Demand�e][Sommation]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Factur�e 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Factur�e][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Familia_articulos.id_familia][Factur�e][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Factur�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Factur�e][Maximum]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Factur�e][Minimum]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Factur�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Factur�e][N�]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Factur�e][Sommation]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Re�ue 
  <input type="hidden" name="totales[Familia_articulos.id_familia][Re�ue][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Re�ue][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Re�ue][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Re�ue][Maximum]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Re�ue][Minimum]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Re�ue][Moyenne]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Re�ue][N�]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Re�ue][Sommation]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Prix de Ventes
  <input type="hidden" name="totales[Familia_articulos.id_familia][Prix][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Familia_articulos.id_familia][Prix][round]" value="2">
  <!-- input type="hidden" name="totales[Familia_articulos.id_familia][Prix][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Prix][Maximum]" value="max"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Prix][Minimum]" value="min"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Prix][Moyenne]" value="avg"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Prix][N�]" value="count"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Familia_articulos.id_familia][Prix][Sommation]" value="sum"
  @%func:checkbox_mark;Familia_articulos.id_familia;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

</table>

<br>
<table class="full">
  <tr><td class="caption" colspan="11">Articles</td></tr>

  <tr>
  <td class="etiqueta">ID:</td>
  <td colspan="4"><input type="text" name="ar_id" size="20" class="insertext" value="@%get:st[ar_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="4"><input type="text" name="ar_nombre" size="30" class="insertext" value="@%get:st[ar_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="11">Factures</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">R�f. Ext:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">S�rie:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">Aucune s�lection</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=1;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">Depuis:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">Jusqu-�:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Revenu imposable > :</td>
  <td colspan="2"><input type=text name="fr_basei" size="20" class="insertext" value="@%get:st[fr_basei];%@"></td>
  </tr>

  <tr><td class="titulotb" colspan="11">Ordre pr�s</td></tr>
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
  Prix Moyen
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
  <td colspan="2" class="titul1al" >Rem.</td>
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
  <td class="etiqueta" colspan="2" >Quantit� Demand�e</td>

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
  <td class="titul1al" colspan="2">Rem.</td>
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
  <td class="etiqueta" colspan="2">Article</td>

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
  <td class="titul1al">Rem.</td>

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
  <td class="caption" colspan="10">Agents</td>
  </tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="ag_id" size="20" class="insertext" value="@%get:st[ag_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="2"><input type="text" name="ag_nombre" size="30" class="insertext" value="@%get:st[ag_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Type:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[ag_tipo];%@ -->
  <select name="ag_tipo" class="insertext">
  <option value="">Aucune s�lection</option>
  @%where:tabla|Tipo_agente;nolink|1;nombre|tipos;%@
  <option value="@%db:Tipo_agente.id_tipo_agente;%@"
  @%db:selected_value{Tipo_agente.id_tipo_agente}%@
  >@%db:Tipo_agente.nombre;%@</option>
  @%end-where:%@

  </select>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Demand�e 
  <input type="hidden" name="totales[Agentes.id_agente][Demand�e][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Agentes.id_agente][Demand�e][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Demand�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Demand�e][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Demand�e][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Demand�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Demand�e][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Demand�e][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Factur�e 
  <input type="hidden" name="totales[Agentes.id_agente][Factur�e][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Agentes.id_agente][Factur�e][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Factur�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Factur�e][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Factur�e][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Factur�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Factur�e][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Factur�e][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Re�ue 
  <input type="hidden" name="totales[Agentes.id_agente][Re�ue][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Agentes.id_agente][Re�ue][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Re�ue][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Re�ue][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Re�ue][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Re�ue][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Re�ue][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Re�ue][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Prix de Ventes
  <input type="hidden" name="totales[Agentes.id_agente][Prix][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Agentes.id_agente][Prix][round]" value="2">
  <!-- input type="hidden" name="totales[Agentes.id_agente][Prix][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Prix][Maximum]" value="max"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Prix][Minimum]" value="min"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Prix][Moyenne]" value="avg"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Prix][N�]" value="count"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Agentes.id_agente][Prix][Sommation]" value="sum"
  @%func:checkbox_mark;Agentes.id_agente;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Sommation
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
  <td class="caption" colspan="10">Clients</td>
  </tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="cl_id" size="20" class="insertext" value="@%get:st[cl_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="2"><input type="text" name="cl_nombre" size="30" class="insertext" value="@%get:st[cl_nombre];%@"></td>
  <td class="etiqueta" colspan="2">Type:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[cl_tipo];%@ -->
  <select name="cl_tipo" class="insertext">
  <option value="">Aucune s�lection</option>
  @%where:tabla|Tipo_cliente;nolink|1;nombre|tiposcl;%@
  <option value="@%db:Tipo_cliente.id_tipo_cliente;%@"
  @%db:selected_value{Tipo_cliente.id_tipo_cliente}%@
  >@%db:Tipo_cliente.nombre;%@</option>
  @%end-where:%@

  </select>
  </td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totals</td></tr>

  <tr>
  <td class="etiqueta" >Quantit� Demand�e 
  <input type="hidden" name="totales[Clientes.id_cliente][Demand�e][field]" value="Lineas_detalle.cantidad">
  <input type="hidden" name="totales[Clientes.id_cliente][Demand�e][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Demand�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Demand�e][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Demand�e][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Demand�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Demand�e][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Demand�e][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Factur�e 
  <input type="hidden" name="totales[Clientes.id_cliente][Factur�e][field]" 
  		value="IF(Facturas.factura_abono,(Facturas_detalle.cantidad*-1),Facturas_detalle.cantidad)" />
  <input type="hidden" name="totales[Clientes.id_cliente][Factur�e][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Factur�e][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Factur�e][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Factur�e][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <!-- input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Factur�e][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;avg;%@ -->
  </td><td>
  <!-- Moyenne -->
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Factur�e][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Factur�e][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Facturas_detalle.cantidad;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantit� Re�ue 
  <input type="hidden" name="totales[Clientes.id_cliente][Re�ue][field]" value="Lineas_detalle.cantidad_recibida">
  <input type="hidden" name="totales[Clientes.id_cliente][Re�ue][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Re�ue][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Re�ue][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Re�ue][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Re�ue][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Re�ue][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Re�ue][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.cantidad_recibida;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Prix de Ventes
  <input type="hidden" name="totales[Clientes.id_cliente][Prix][field]" value="Lineas_detalle.precio_articulo">
  <input type="hidden" name="totales[Clientes.id_cliente][Prix][round]" value="2">
  <!-- input type="hidden" name="totales[Clientes.id_cliente][Prix][erase_without]" value="ag_search" -->
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Prix][Maximum]" value="max"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Prix][Minimum]" value="min"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Prix][Moyenne]" value="avg"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Prix][N�]" value="count"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;count;%@>
  </td><td>
  N�
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Clientes.id_cliente][Prix][Sommation]" value="sum"
  @%func:checkbox_mark;Clientes.id_cliente;Lineas_detalle.precio_articulo;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

</table>
<br>
  </form>

