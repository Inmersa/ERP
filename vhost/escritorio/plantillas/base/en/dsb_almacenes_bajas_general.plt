
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>General Indicators</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicator</td>
<td>Stock Downs</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@ @%set:dsb_rs_limit=7;%@ @%set:dsb_grfx_field=bajas_stock;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@</td>
<td>@%db:lcdec{bajas_stock};%@</td>
</tr>
@%end-where:%@

</tbody></table>
@%func:dsb_grfx_horizontal;general;bajas_stock;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_general[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@
</fieldset>

