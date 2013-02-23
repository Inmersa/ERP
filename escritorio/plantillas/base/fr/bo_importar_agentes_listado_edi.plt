
@%plt:botonera%@
<form name ="bo_importar_agentes" method="post" action="">
<table class="full">
<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Téléphone</td>
<td class="caption">Tipe d´agent</td>
</tr>

@%where:tabla|Agentes;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="importar_agentes[@%db:Agentes.id_agente;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_agentes&id_agente=@%db:Agentes.id_agente;%@">@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</a></td>
<td>@%db:Agentes.telefono1;%@</td>
<td>@%db:Tipo_agente.nombre%@</td>
</tr>

@%end-where:%@


<input type="hidden" name="accion_ejecutar" value="Importar" />

</table>
</form>
@%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['bo_importar_agentes'].submit();">Importer</a></div>


