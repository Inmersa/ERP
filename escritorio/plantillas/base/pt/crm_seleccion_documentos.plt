
@%plt:botonera%@

<form action="?seccion=@%func:inm_prev_subsec%@" name="importar_usuario" method="post">
<input type="hidden" name="accion_ejecutar" value="Seleccion_documentos_crm" />
<table class="full">
 <!-- @%set:_inm_count_times=2;%@ -->
<tr>
@%where:tabla|Documentos;nombre|busc;order|Documentos.nombre;nombre|busc;no_results|1;%@ 
<!--@%db:Documentos.id_documento%@ -->
 <td class="check">
 <input type="checkbox" name="selecciones[@%db:Documentos.id_documento;%@]" value="@%db:Documentos.id_documento%@" 
 @%func:selected_document;Documentos.id_documento;%@
 /></td>
 
 <td>@%db:Documentos.nombre;%@ - @%db:Tipos_documento.nombre;%@ (@%db:Agrupaciones_documentos.nombre;%@)</td>
 @%if:inm_count;%@
</tr><tr>
@%end-if:%@

@%end-where:%@

</tr>
</table>
</form>

@%plt:botonera%@

<div class="enviar"><a href="" onclick="return sendForm('importar_usuario');">Aceitar Itens Seleccionados</a></div>

