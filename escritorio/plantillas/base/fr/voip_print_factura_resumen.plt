@%where:format_name|classDocumentDetail;%@

@%set:_page_css = paginacabecera;%@
@%plt:print_pagebreak;%@

@%if:!esta_vacio;factura_abono;%@
@%set:es_abono=1;%@
@%end-if:%@

@%if:ModVoIP->isMixedInvoice;%@
<div class="resumen" >

<table class="subtotal">
<thead><tr>
<td class="nombregrupo" >Article</td>
<td>Quantite</td>
<td>Prix</td>
<td>Rem.</td>
<td>Totals</td>
</tr></thead>

<tbody>
@%where:nodb|voipnodb_noip_list;nombre|productosNoIP;format_name|classDocumentDetail;%@

@%if:!esta_vacio;romper_linea;%@
	</tbody></table></div>
	@%set:_page_css = pagina;%@
	@%plt:print_pagebreak;%@
	<!-- @%set:_var_x_reset=1;%@ @%set:primera_vez=1;%@ -->

	<div class="titulo">Résumé par Numéro</div>
	<div class="resumen" >
	<table class="subtotal">
	<thead><tr>
	<td class="nombregrupo" >Article</td>
	<td>Quantite</td>
	<td>Prix</td>
	<td>Rem.</td>
	<td>Totals</td>
	</tr></thead><tbody>
@%end-if:%@

<tr>
<td class="nombregrupo" >@%db:nombre;%@</td>
<td >@%db:cantidad;%@</td>

 <td >@%db:precio;%@
@%if:!esta_vacio;leyenda_unidad_medida;%@
/ @%db:leyenda_unidad_medida;%@
@%end-if:%@
</td>

<td >@%db:tipo_descuento_fmt;%@</td>
<td >@%db:base_imponible;%@</td>
</tr>
@%end-where:%@

</tbody></table>
</div>
@%end-if:%@

<div class="titulo">Résumé par Numéro</div>
<div class="resumen" >

<table class="subtotal">
<thead><tr>
<td class="nombregrupo" >Téléphone</td>
<td>Durée</td>
<td>Consommation</td>
<td>Remise</td>
<td>Totals</td>
</tr></thead>

<tbody>
<!-- @%set:resume_index=origen;%@ -->
@%where:nodb|voipnodb_order_orig_resume;nombre|resumenNumero;format_name|classDocumentDetail;%@

@%if:!esta_vacio;romper_linea;%@
	</tbody></table></div>
	@%set:_page_css = pagina;%@
	@%plt:print_pagebreak;%@
	<!-- @%set:_var_x_reset=1;%@ @%set:primera_vez=1;%@ -->

<div class="titulo">Résumé par Numéro</div>
<div class="resumen" >
<table class="subtotal">
<thead><tr>
<td class="nombregrupo" >Téléphone</td>
<td>Durée</td>
<td>Consommation</td>
<td>Remise</td>
<td>Totals</td>
</tr></thead>

<tbody>
@%end-if:%@

<tr>
<td class="nombregrupo" >@%db:grupo0;%@</td>
<td >@%db:cantidad;%@</td>
<td >@%db:bruto;%@</td>
<td >@%db:importe_descuento;%@</td>
<td >@%db:base_imponible;%@</td>
</tr>
@%end-where:%@

</tbody></table>
</div>

<div class="titulo">Résumé par Concept</div>
<div class="resumen" >

<!-- @%set:resume_index=familia;%@ @%set:primera_vez=1;%@-->
@%where:nodb|voipnodb_order_orig_resume;nombre|resumenGrupo;%@
<!-- @%set:_var_x = grupo0;%@ -->

@%if:!esta_vacio;romper_linea;%@
	</tbody></table></div>
	@%set:_page_css = pagina;%@
	@%plt:print_pagebreak;%@
	<!-- @%set:_var_x_reset=1;%@ @%set:primera_vez=1;%@ -->
@%end-if:%@

@%if:cambia_var_x;%@

@%if:esta_vacio;primera_vez;%@
</tbody></table>
@%else:%@
<!-- @%set:primera_vez=0;%@ -->
@%end-if:%@

<div class="grupo" >@%db:grupo0;%@</div>

<table class="subtotal">
<thead><tr>
<td class="nombregrupo" >Concept</td>
<td>Durée</td>
<td>Consommation</td>
<td>Remise</td>
<td>Totals</td>
</tr></thead>

<tbody>
@%end-if:%@
<tr>
<td class="nombregrupo" >@%db:grupo1;%@</td>
<td >@%db:cantidad;%@</td>
<td >@%db:bruto;%@</td>
<td >@%db:importe_descuento;%@</td>
<td >@%db:base_imponible;%@</td>
</tr>
@%end-where:%@

</tbody></table>
</div>

</div>

