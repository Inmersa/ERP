
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Compared Sales</legend>

<table class="full" >
@%set:dsb_resultados=comparadas;%@
@%set:dsb_rs_limit=7;%@
@%set:dsb_an_limit=3;%@

@%where:nodb|nodb_dsb_resultados_anual;%@

@%if:!esta_vacio;poner_cabecera;%@
<thead class="dashboard" >
<tr><td ></td>
<td colspan="@%get:_iterate_times;%@" >Sales</td>
<td colspan="@%get:_iterate_times;%@" >Received</td></td>

<tr><td >Period</td>
<!-- Aqui falta ponerle el encabezado del valor que sera (Ventas) -->
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_anyo{iterate_num};%@</td>
@%end-where:%@

<!-- Aqui falta ponerle el encabezado del valor que sera (Ventas) -->
<!-- @%set:_iterate_reset=1;%@ -->
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_anyo{iterate_num};%@</td>
@%end-where:%@

</tr></thead><tbody class="dashboard" >
@%end-if:%@

<tr>
<td>@%db:_periodo;%@</td>

<!-- @%set:_iterate_reset=1;%@ @%set:_dsb_resultados_anual_valor=ventas;%@ -->
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_valor{iterate_num};%@</td>
@%end-where:%@

<!-- @%set:_iterate_reset=1;%@ @%set:_dsb_resultados_anual_valor=cobrado;%@ -->
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_valor{iterate_num};%@</td>
@%end-where:%@

</tr>
@%end-where:%@

</tbody></table>

@%func:dsb_grfx_comparadas;ventas;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Compared Sales;%@
@%set:grafica[limit] = dsb_rs_limit;%@
-->
@%plt:Grafica;%@
@%end-if:%@

@%func:dsb_grfx_comparadas;cobrado;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Received Compared;%@
@%set:grafica[limit] = dsb_rs_limit;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

