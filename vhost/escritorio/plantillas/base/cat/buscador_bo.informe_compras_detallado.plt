
<form method=post action="?seccion=informe_compras_detallado">
<input type="hidden" name="nom_bus" value="informe_compras_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Informe Detallat de Facturació en Compres</td>
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
  <tr><td align="left" class="caption" colspan="11">Grup de Proveïdors</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="pr_id" size="20" class="insertext" value="@%get:st[pr_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="6"><input type="text" name="pr_nombre" size="30" class="insertext" value="@%get:st[pr_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="12">Factures</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ref. Ext:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Serié:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">Cap selecció</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=0;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">Des de:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">Fins:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Base imposable > :</td>
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
  <td class="caption" colspan="10">Efectes</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incidències</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totals</td></tr><tr>

  <td class="etiqueta" >Base imposable
  <input type="hidden" name="totales[Proveedores.id_proveedor][Base imposable][field]" value="Facturas.base_imponible">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Base imposable][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base imposable][Màxim]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;max;%@>
  </td><td>
  Valor Màxim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base imposable][Mínim]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;min;%@>
  </td><td>
  Valor Mínim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base imposable][Mig]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;avg;%@>
  </td><td>
  Terme Mitjà
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base imposable][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Base imposable][Sumatori]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;sum;%@>
  </td><td>
  Sumatori
  </td></tr>

  <tr>
  <td class="etiqueta" >Totals Imposts
  <input type="hidden" name="totales[Proveedores.id_proveedor][Totals Imposts][field]" value="Facturas.total_impuestos">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Totals Imposts][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Imposts][Màxim]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor Màxim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Imposts][Mínim]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor Mínim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Imposts][Mig]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;avg;%@>
  </td><td>
  Terme Mitjà
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Imposts][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Imposts][Sumatori]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retingut
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retingut][field]" value="Facturas.retenido">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retingut][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retingut][Màxim]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;max;%@>
  </td><td>
  Valor Màxim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retingut][Mínim]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;min;%@>
  </td><td>
  Valor Mínim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retingut][Mig]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;avg;%@>
  </td><td>
  Terme Mitjà
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retingut][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retingut][Sumatori]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Import gros
  <input type="hidden" name="totales[Proveedores.id_proveedor][Import gros][field]" value="Facturas.total_bruto">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Import gros][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Import gros][Màxim]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;max;%@>
  </td><td>
  Valor Màxim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Import gros][Mínim]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;min;%@>
  </td><td>
  Valor Mínim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Import gros][Mig]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;avg;%@>
  </td><td>
  Terme Mitjà
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Import gros][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Import gros][Sumatori]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Quantia
  <input type="hidden" name="totales[Proveedores.id_proveedor][Quantia][field]" value="Facturas.monto_total">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Quantia][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Quantia][Màxim]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;max;%@>
  </td><td>
  Valor Màxim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Quantia][Mínim]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;min;%@>
  </td><td>
  Valor Mínim
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Quantia][Mig]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;avg;%@>
  </td><td>
  Terme Mitjà
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Quantia][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Quantia][Sumatori]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;sum;%@>
  </td><td>
  Sumatori
  </td>
  </tr>

</table>
<br>

<br>
  </form>

