@%plt:botonera%@

<form name="tarifas_transporte" action="?seccion=bo_tarifas_transporte" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar">
<table class="full">
<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Pes inicial</td>
<td class="caption">Pes final</td>
<td class="caption">Coste</td>
</tr>
 @%where:tabla|Tarifas_transporte;nombre|busc;%@
<tr>
<td class="check"><input type="checkbox" 
	name="borrar[@%db:Tarifas_transporte.id_tarifa_transporte;%@]" value="1" class="insertext"></td>
<td class="etiqueta"><a href="?seccion=modif_tarifas_transporte&id_tarifa_transporte=@%db:Tarifas_transporte.id_tarifa_transporte;%@">@%db:Tarifas_transporte.nombre;%@</a></td>
<td>@%db:Tarifas_transporte.peso_inicial;%@ </td>
<td>@%db:Tarifas_transporte.peso_final;%@</td>
<td>@%db:Tarifas_transporte.costo;%@</td>
</tr>
@%end-where:%@


</table>
@%plt:botonera%@
<div class="enviar"><a href="#"
	onClick="return sendForm('tarifas_transporte');" 
 	>Esborrar seleccionats</a></div>
</form>

