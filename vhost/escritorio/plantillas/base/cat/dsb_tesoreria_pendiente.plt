
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Vendes Comparades</legend>

<table class="full" >
@%set:dsb_resultados=pendiente;%@
@%set:dsb_rs_limit=7;%@
@%set:dsb_an_limit=3;%@

@%where:nodb|nodb_dsb_resultados_anual;%@

@%if:!esta_vacio;poner_cabecera;%@
<thead class="dashboard" >
<tr><td ></td>
<td colspan="@%get:_iterate_times;%@" >Per Pagar</td>
<td colspan="@%get:_iterate_times;%@" >Per Cobrar</td></td>

<tr><td >Període</td>
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

<!-- @%set:_iterate_reset=1;%@ @%set:_dsb_resultados_anual_valor=pendiente_cobros;%@ -->
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_valor{iterate_num};%@</td>
@%end-where:%@

<!-- @%set:_iterate_reset=1;%@ @%set:_dsb_resultados_anual_valor=pendiente_pagos;%@ -->
@%where:nodb|nodb_iterate;%@
<td>@%db:dsb_resultados_anual_valor{iterate_num};%@</td>
@%end-where:%@

</tr>
@%end-where:%@

</tbody></table>

@%func:dsb_grfx_comparadas;pendiente;pendiente_cobros;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Per Pagar;%@
@%set:grafica[limit] = dsb_rs_limit;%@
-->
@%plt:Grafica;%@
@%end-if:%@

@%func:dsb_grfx_comparadas;pendiente;pendiente_pagos;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Per Cobrar;%@
@%set:grafica[limit] = dsb_rs_limit;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

