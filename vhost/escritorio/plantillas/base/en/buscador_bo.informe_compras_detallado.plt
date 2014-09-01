
<form method=post action="?seccion=informe_compras_detallado">
<input type="hidden" name="nom_bus" value="informe_compras_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Purchases: Detailed Invoicing report</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Search" class="insertext" accesskey="f" >
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
  <tr><td align="left" class="caption" colspan="11">Suppliers Group</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="pr_id" size="20" class="insertext" value="@%get:st[pr_id];%@"></td>
  <td class="etiqueta" colspan="2">Name:</td>
  <td colspan="6"><input type="text" name="pr_nombre" size="30" class="insertext" value="@%get:st[pr_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="12">Invoices</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ext. Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Serial:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">No selection</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=0;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">From:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">To:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Taxable Income > :</td>
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
  <td class="caption" colspan="10">Drafts</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Events</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Total</td></tr><tr>

  <td class="etiqueta" >Taxable Income
  <input type="hidden" name="totales[Proveedores.id_proveedor][Taxable Income][field]" value="Facturas.base_imponible">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Taxable Income][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Taxable Income][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Taxable Income][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Taxable Income][Average]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;avg;%@>
  </td><td>
  Average
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Taxable Income][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Taxable Income][Summation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;sum;%@>
  </td><td>
  Summation
  </td></tr>

  <tr>
  <td class="etiqueta" >Total Taxes
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Taxes][field]" value="Facturas.total_impuestos">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Taxes][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Taxes][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Taxes][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Taxes][Average]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;avg;%@>
  </td><td>
  Average
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Taxes][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Taxes][Summation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retained
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retained][field]" value="Facturas.retenido">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retained][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retained][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retained][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retained][Average]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;avg;%@>
  </td><td>
  Average
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retained][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retained][Summation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Gross Total
  <input type="hidden" name="totales[Proveedores.id_proveedor][Gross Total][field]" value="Facturas.total_bruto">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Gross Total][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Gross Total][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Gross Total][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Gross Total][Average]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;avg;%@>
  </td><td>
  Average
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Gross Total][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Gross Total][Summation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Amount
  <input type="hidden" name="totales[Proveedores.id_proveedor][Amount][field]" value="Facturas.monto_total">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Amount][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Amount][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;max;%@>
  </td><td>
  Maximum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Amount][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;min;%@>
  </td><td>
  Minimum Value
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Amount][Average]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;avg;%@>
  </td><td>
  Average
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Amount][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Amount][Summation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;sum;%@>
  </td><td>
  Summation
  </td>
  </tr>

</table>
<br>

<br>
  </form>

