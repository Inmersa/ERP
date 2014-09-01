
<!-- @%unset:grafica;%@ @%unset:leyenda;%@ -->
<fieldset class="fsficha" >
<legend>Achats Comparés</legend>

<table class="full" >
@%set:dsb_resultados=comparadas;%@
@%set:dsb_rs_limit=7;%@
@%set:dsb_an_limit=3;%@

@%where:nodb|nodb_dsb_resultados_anual;%@

@%if:!esta_vacio;poner_cabecera;%@
<thead class="dashboard" >
<tr><td ></td>
<td colspan="@%get:_iterate_times;%@" >Achats</td>
<td colspan="@%get:_iterate_times;%@" >Perçu</td></td>

<tr><td >Période</td>
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_anyo{iterate_num};%@</td>
@%end-where:%@

<!-- @%set:_iterate_reset=1;%@ -->
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_anyo{iterate_num};%@</td>
@%end-where:%@

</tr></thead><tbody class="dashboard" >
@%end-if:%@

<tr>
<td>@%db:_periodo;%@</td>

<!-- @%set:_iterate_reset=1;%@ @%set:_dsb_resultados_anual_valor=compras;%@ -->
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

@%func:dsb_grfx_comparadas;compras;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Achats Comparés;%@
@%set:grafica[limit] = dsb_rs_limit;%@
-->
@%plt:Grafica;%@
@%end-if:%@

@%func:dsb_grfx_comparadas;cobrado;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Perçu Comparé;%@
@%set:grafica[limit] = dsb_rs_limit;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

