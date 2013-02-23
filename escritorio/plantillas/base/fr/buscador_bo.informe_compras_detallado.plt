
<form method=post action="?seccion=informe_compras_detallado">
<input type="hidden" name="nom_bus" value="informe_compras_detallado">
<table class="full">
  <tr> 
  <td class="caption" align="left">Rapport Détaillé de Facturation dans des achats</td>
  <td class="caption" align="right">
        <input type="submit" name="Buscar" value="Chercher" class="insertext" accesskey="r" >
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
  <tr><td align="left" class="caption" colspan="11">Groupe de fournisseurs</td></tr>

  <tr><td class="etiqueta">ID:</td>
  <td colspan="2"><input type="text" name="pr_id" size="20" class="insertext" value="@%get:st[pr_id];%@"></td>
  <td class="etiqueta" colspan="2">Nom:</td>
  <td colspan="6"><input type="text" name="pr_nombre" size="30" class="insertext" value="@%get:st[pr_nombre];%@"></td>
  </tr>

  <tr><td class="caption" colspan="12">Factures</td></tr>

  <tr><td class="etiqueta">Ref.:</td>
  <td colspan="2"><input type="text" name="fr_ref" size="20" class="insertext" value="@%get:st[fr_ref];%@"></td>
  <td class="etiqueta" colspan="2">Réf. Ext:</td>
  <td colspan="2"><input type="text" name="fr_ref_ext" size="30" class="insertext" value="@%get:st[fr_ref_ext];%@"></td>
  <td class="etiqueta" colspan="2">Série:</td>
  <td colspan="2"><!-- @%set:_selected_value=st[fr_serie];%@ -->
  <select name="fr_serie" class="insertext">
  <option value="">Aucune sélection</option>
  @%where:tabla|Series_facturacion;nolink|1;nombre|seriesfra;where|ventas=0;%@
  <option value="@%db:Series_facturacion.id_serie;%@"
  @%db:selected_value{Series_facturacion.id_serie}%@
  >@%db:Series_facturacion.nombre;%@ 
  (@%db:si_no_flag{Series_facturacion.contabilizable}%@)</option>
  @%end-where:%@

  </select>
  </tr>

  <tr><td class="etiqueta">Depuis:</td>
  <td colspan="2"><input type=text name="fr_fecha_inicio" size="20" class="insertext" value="@%get:st[fr_fecha_inicio];%@"></td>
  <td class="etiqueta" colspan="2">Jusqu-à:</td>
  <td colspan="2"><input type=text name="fr_fecha_fin" size="20" class="insertext" value="@%get:st[fr_fecha_fin];%@"></td>
  <td class="etiqueta" colspan="2">Revenu imposable > :</td>
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
  <td class="caption" colspan="10">Effets</td>
  </tr>

  <tr>
  <td class="check" >
  <input type="checkbox" name="ic_search" value="1"
  @%if:esta_vacio;st[ic_search];%@
  @%else:@
  checked="checked"
  @%end-if:%@
  ></td>
  <td class="caption" colspan="10">Incidences</td>
  </tr>

  <tr><td class="titulotb" colspan="11">Totals</td></tr><tr>

  <td class="etiqueta" >Revenu imposable
  <input type="hidden" name="totales[Proveedores.id_proveedor][Revenu imposable][field]" value="Facturas.base_imponible">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Revenu imposable][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Revenu imposable][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Revenu imposable][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Revenu imposable][Moyenne]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Revenu imposable][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Revenu imposable][Sommation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.base_imponible;sum;%@>
  </td><td>
  Sommation
  </td></tr>

  <tr>
  <td class="etiqueta" >Totals Impôt
  <input type="hidden" name="totales[Proveedores.id_proveedor][Totals Impôt][field]" value="Facturas.total_impuestos">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Totals Impôt][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Impôt][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Impôt][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Impôt][Moyenne]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Impôt][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Totals Impôt][Sommation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_impuestos;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Maintenu
  <input type="hidden" name="totales[Proveedores.id_proveedor][Maintenu][field]" value="Facturas.retenido">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Maintenu][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Maintenu][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Maintenu][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Maintenu][Moyenne]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Maintenu][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Maintenu][Sommation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.retenido;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Total Brut
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Brut][field]" value="Facturas.total_bruto">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Total Brut][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Brut][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Brut][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Brut][Moyenne]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Brut][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Total Brut][Sommation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.total_bruto;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

  <tr>
  <td class="etiqueta" >Montant
  <input type="hidden" name="totales[Proveedores.id_proveedor][Montant][field]" value="Facturas.monto_total">
  <input type="hidden" name="totales[Proveedores.id_proveedor][Montant][round]" value="2">
  </td>
  <td class="check" >
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montant][Maximum]" value="max"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;max;%@>
  </td><td>
  Valeur Maximale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montant][Minimum]" value="min"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;min;%@>
  </td><td>
  Valeur Minimale
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montant][Moyenne]" value="avg"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;avg;%@>
  </td><td>
  Moyenne
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montant][Nº]" value="count"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;count;%@>
  </td><td>
  Nº
  </td><td class="check">
  <input type="checkbox" class="insertext" name="totales[Proveedores.id_proveedor][Montant][Sommation]" value="sum"
  @%func:checkbox_mark;Proveedores.id_proveedor;Facturas.monto_total;sum;%@>
  </td><td>
  Sommation
  </td>
  </tr>

</table>
<br>

<br>
  </form>

