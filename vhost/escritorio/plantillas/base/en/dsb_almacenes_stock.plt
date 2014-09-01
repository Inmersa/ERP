
<fieldset class="fsficha" >
<legend>Stock</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicator</td>
<td>Stock Value: Sales</td>
<td>Stock Value: Stock Downs</td>
<td>Installments</td>
<td>Stock Value: Purchases</td>
<td>Stock Value</td>
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

