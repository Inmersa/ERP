
<fieldset class="fsficha" >
<legend>Indicadores Generales</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicador</td>
<td>Valores en Compra</td>
<td>Pedido en Compras</td>
<td>{{dsb_lbl_servido_compra}}</td>
<td>Devoluciones en Compras</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{indicador_base};%@</td>
<td>@%db:lcdec{pedidos};%@</td>
<td>@%db:lcdec{servido};%@</td>
<td>@%db:lcdec{devoluciones};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

