
<fieldset class="fsficha" >
<legend>Indicadors Generals</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicador</td>
<td>VValors per Venda</td>
<td>Abonaments</td>
<td>Comanda en Vendes</td>
<td>Devolucions en Vendes</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{indicador_base};%@</td>
<td>@%db:lcdec{abonos};%@</td>
<td>@%db:lcdec{pedidos};%@</td>
<td>@%db:lcdec{devoluciones};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

