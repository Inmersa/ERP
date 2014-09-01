
<fieldset class="fsficha" >
<legend>Indicadors Generals</legend>

<table class="full" >
<thead class="dashboard" ><tr>
<td>Indicador</td>
<td>Comanda en Vendes</td>
<td>Servit en Vendes</td>
<td>Comanda en Compres</td>
<td>Servit en Compres</td>
</tr></thead><tbody class="dashboard" >

@%set:dsb_resultados=general;%@
@%set:dsb_rs_limit=7;%@
@%where:nodb|nodb_dsb_resultados_horizontal;%@
<tr>
<td>@%db:_periodo;%@ [@%db:colocar_fecha{_inicio};%@ - @%db:colocar_fecha{_fin};%@]</td>
<td>@%db:lcdec{ventas};%@</td>
<td>@%db:lcdec{servido_ventas};%@</td>
<td>@%db:lcdec{compras};%@</td>
<td>@%db:lcdec{servido_compras};%@</td>
</tr>
@%end-where:%@

</tbody></table>
</fieldset>

