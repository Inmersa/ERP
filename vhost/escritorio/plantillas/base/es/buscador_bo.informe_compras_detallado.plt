
<form method=post action="?seccion=informe_compras_detallado">
<input type="hidden" name="nom_bus" value="informe_compras_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Informe Detallado de Facturación en compras</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Buscar" class="insertext" accesskey="b" >
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
<table class="full" >
  <tr><td align="left" class="caption" colspan="11">Grupo de proveedores</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="pr_id" size="20" class="insertext" value="@%get:st[pr_id];%@"></td>
  <td class="etiqueta" colspan="2">Nombre:</td>
  <td colspan="6"><input type="text" name="pr_nombre" size="30" class="insertext" value="@%get:st[pr_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="12">Facturas</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ref. externa:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Serie:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">-- Ninguna seleccion --</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=0;%@
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

  <tr>
  <td class="check" >
  <input type="checkbox" name="ef_search" value="1"
  @%if:esta_vacio;st[ef_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Efectos</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incidencias</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totales</td></tr><tr>

  <td class="etiqueta" >Base Imponible
  <input type="hidden" name="totales[Proveedores.id_proveedor][Base Imponible][field]" value="Facturas.base_imponible">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Base Imponible][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base Imponible][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base Imponible][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base Imponible][Media]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base Imponible][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base Imponible][Sumatorio]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;sum;%@>
  </td><td>
  Suma
  </td></tr>

  <tr>
  <td class="etiqueta" >Total Impuestos
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Impuestos][field]" value="Facturas.total_impuestos">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Impuestos][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Impuestos][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Impuestos][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Impuestos][Media]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Impuestos][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Impuestos][Sumatorio]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retenido
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retenido][field]" value="Facturas.retenido">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retenido][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retenido][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retenido][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retenido][Media]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retenido][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retenido][Sumatorio]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Bruto
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Bruto][field]" value="Facturas.total_bruto">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Bruto][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Media]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Sumatorio]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Importe
  <input type="hidden" name="totales[Proveedores.id_proveedor][Importe][field]" value="Facturas.monto_total">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Importe][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Importe][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Importe][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Importe][Media]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;avg;%@>
  </td><td>
  Media
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Importe][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Importe][Sumatorio]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;sum;%@>
  </td><td>
  Suma
  </td>
  </tr>

</table>
<br>

<br>
  </form>

