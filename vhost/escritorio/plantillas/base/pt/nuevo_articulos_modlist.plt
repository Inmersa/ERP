<fieldset class="fsficha">
<legend>M�dulos Asociados</legend>

<table class="full" ><tbody><tr>
<!-- @%set:_inm_count_times=3;%@ -->
@%where:nodb|nodb_modulosasociados;%@
<td class="check" ><input type="checkbox" name="registro[mascara_modulo][@%db:id_modulo;%@]" value="@%db:mascara;%@" /></td>
<td class="etiquetacheck">@%db:nombre;%@</td>
@%if:inm_count;%@
</tr><tr>
@%end-if:%@
@%end-where:%@

</tr></tbody></table>
</fieldset>
