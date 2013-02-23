
<fieldset class="fsficha" >
<legend>Stock</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicateur</td>
<td>Valeur de Stock de Ventes</td>
<td>Valeur de Stock de Baisses</td>
<td>Engrais</td>
<td>Valeur de Stock d'Achats</td>
<td>Valeur de Stock</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=stock;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;cfunc|dsb_almacenes_valor_stock;contador|i;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{valor_stk_ventas};%@</td>
<td>@%db:lcdec{bajas_stock};%@</td>
<td>@%db:lcdec{abonos_ventas};%@</td>
<td>@%db:lcdec{valor_stk_compras};%@</td>
<td>@%db:lcdec{valor_stock};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

