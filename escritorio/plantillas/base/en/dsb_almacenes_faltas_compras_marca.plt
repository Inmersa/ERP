
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Value in Brand</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicator</td>
<td>Value in Purchases</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=top_marcas;%@ @%set:dsb_rs_limit=7;%@ @%set:dsb_grfx_field=indicador_compra;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@</td>
<td>@%db:lcdec{indicador_compra};%@</td>
</tr>
@%end-where:%@

</tbody></table>

@%func:dsb_grfx_horizontal;top_marcas;indicador_compra;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_top_marcas[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

