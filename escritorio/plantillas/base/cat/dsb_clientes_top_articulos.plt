
<!-- @%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@-->
<fieldset class="fsficha" >
<legend>Top Articles</legend>

<!-- table class="full" >
<thead class="dashboard" ><tr>
<td>Article</td>
<td>Vendes</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_rs_limit=10;%@ 
@%set:dsb_resultados=top_articulos;%@

@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr><td>@%db:_periodo;%@</td>
<td>@%db:lcdec{top_articulos};%@</td></tr>
@%end-where:%@

</tbody></table -->

@%func:dsb_grfx_horizontal;top_articulos;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Top Articles;%@
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_top_articulos[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@

</fieldset>

