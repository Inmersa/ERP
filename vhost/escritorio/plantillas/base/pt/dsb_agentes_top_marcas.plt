
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Top Marcas</legend>

<!-- table class="full" >
<thead class="dashboard" ><tr>
<td>Artigo</td>
<td>Vendas</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_rs_limit=10;%@ 
@%set:dsb_resultados=top_marcas;%@

@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr><td>@%db:_periodo;%@</td>
<td>@%db:lcdec{top_marcas};%@</td></tr>
@%end-where:%@

</tbody></table -->

@%func:dsb_grfx_horizontal;top_marcas;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Top Marcas;%@
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_top_marcas[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

