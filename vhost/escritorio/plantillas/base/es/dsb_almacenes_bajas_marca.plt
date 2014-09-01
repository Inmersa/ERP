
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Bajas por Marca</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicador</td>
<td>Bajas</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=top_marcas;%@ @%set:dsb_rs_limit=7;%@ @%set:dsb_grfx_field=bajas_stock;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ 
<td>@%db:lcdec{bajas_stock};%@</td>
</tr>
@%end-where:%@

</tbody></table>
@%func:dsb_grfx_horizontal;top_marcas;bajas_stock;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_general[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@
</fieldset>

