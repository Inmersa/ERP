
<fieldset class="fsficha">
<legend>Configuraci�n CRM</legend>
<table class="full"><tbody>
<tr><td class="etiqueta">Documentos para Presupuestos</td>
<td>
<!-- @%set:_selected_value=_aAppConf[crm_idgrupodocs_presupuestos];%@ -->
<select name="_main[crm_idgrupodocs_presupuestos]" >
<option value="">-- Ninguna seleccion --</option>
@%where:db|crm;tabla|Agrupaciones_documentos;order|nombre;%@
<option value="@%db:Agrupaciones_documentos.id_agrupacion_documentos;%@" 
@%db:selected_value{Agrupaciones_documentos.id_agrupacion_documentos};%@
>@%db:Agrupaciones_documentos.nombre;%@</option>
@%end-where:%@

</select></td></tr></tbody></table>
</fieldset>

