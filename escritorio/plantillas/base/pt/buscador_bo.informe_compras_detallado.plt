
<form method=post action="?seccion=informe_compras_detallado">
<input type="hidden" name="nom_bus" value="informe_compras_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Relatório Detalhado de Facturação em compras</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Pesquisar" class="insertext" accesskey="p" >
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
  <tr><td align="left" class="caption" colspan="11">Grupo de fornecedores</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="pr_id" size="20" class="insertext" value="@%get:st[pr_id];%@"></td>
  <td class="etiqueta" colspan="2">Nome:</td>
  <td colspan="6"><input type="text" name="pr_nombre" size="30" class="insertext" value="@%get:st[pr_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="12">Facturas</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Ref. Externa:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Série de Facturação:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">Não Existem Itens Seleccionados</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=0;%@
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

  <tr>
  <td class="check" >
  <input type="checkbox" name="ef_search" value="1"
  @%if:esta_vacio;st[ef_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Ordens de Pagamento</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incidência</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totais</td></tr><tr>

  <td class="etiqueta" >Total do Valor Tributado
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total do Valor Tributado][field]" value="Facturas.base_imponible">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total do Valor Tributado][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total do Valor Tributado][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total do Valor Tributado][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total do Valor Tributado][Média]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total do Valor Tributado][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total do Valor Tributado][Soma]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;sum;%@>
  </td><td>
  Soma
  </td></tr>

  <tr>
  <td class="etiqueta" >Totais Impostos
  <input type="hidden" name="totales[Proveedores.id_proveedor][Totais Impostos][field]" value="Facturas.total_impuestos">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Totais Impostos][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totais Impostos][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totais Impostos][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totais Impostos][Média]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totais Impostos][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totais Impostos][Soma]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Retido
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retido][field]" value="Facturas.retenido">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Retido][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retido][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retido][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retido][Média]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retido][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Retido][Soma]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;sum;%@>
  </td><td>
  Soma
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
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Média]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Bruto][Soma]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Montante
  <input type="hidden" name="totales[Proveedores.id_proveedor][Montante][field]" value="Facturas.monto_total">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Montante][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montante][Máximo]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;max;%@>
  </td><td>
  Valor Máximo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montante][Mínimo]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;min;%@>
  </td><td>
  Valor Mínimo
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montante][Média]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;avg;%@>
  </td><td>
  Média
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montante][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montante][Soma]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;sum;%@>
  </td><td>
  Soma
  </td>
  </tr>

</table>
<br>

<br>
  </form>

