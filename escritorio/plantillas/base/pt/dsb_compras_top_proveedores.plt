
<!-- 
@%unset:dsb_graficas_lineal;%@ @%unset:grafica;%@ @%unset:leyenda;%@ @%unset:dsb_rs_limit;%@
@%unset:dsb_cabecera_ok;%@ @%set:dsb_rs_limit=10;%@ @%set:dsb_resultados=top_proveedores;%@
-->

<fieldset class="fsficha" >
<legend>Top Fornecedor</legend>

@%where:nodb|nodb_dsb_resultados_horizontal;contador|i;%@
@%if:equals;i;1;%@
<!-- table class="full" >
<thead class="dashboard" ><tr>
<td>Fornecedores</td>
<td>Compras</td>
</tr></thead><tbody class="dashboard" >
@%set:dsb_cabecera_ok=1;%@
@%end-if:%@

<tr><td>@%db:_periodo;%@</td>
<td>@%db:lcdec{top_proveedores};%@</td></tr>
@%end-where:%@

@%if:!esta_vacio;dsb_cabecera_ok;%@
</tbody></table -->

@%func:dsb_grfx_horizontal;top_proveedores;%@
@%if:!esta_vacio;mostrar_grafica;%@
<!-- 
@%set:grafica[titulo] = Top Fornecedores;%@
@%set:grafica[limit] = dsb_rs_limit;%@
@%set:graph_top_proveedores[titulo] = nombre_periodo_actual;%@
-->
@%plt:Grafica;%@
@%end-if:%@

@%end-if:%@

</fieldset>

