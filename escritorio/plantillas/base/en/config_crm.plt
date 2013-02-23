
<fieldset class="fsficha">
<legend>CRM Configuration</legend>
<table class="full"><tbody>
<tr><td class="etiqueta">Budgets Documents</td>
<td>
<!-- @%set:_selected_value=_aAppConf[crm_idgrupodocs_presupuestos];%@ -->
<select name="_main[crm_idgrupodocs_presupuestos]" >
<option value="">No selection</option>
@%where:db|crm;tabla|Agrupaciones_documentos;order|nombre;%@
<option value="@%db:Agrupaciones_documentos.id_agrupacion_documentos;%@" 
@%db:selected_value{Agrupaciones_documentos.id_agrupacion_documentos};%@
>@%db:Agrupaciones_documentos.nombre;%@</option>
@%end-where:%@

</select></td></tr></tbody></table>
</fieldset>

