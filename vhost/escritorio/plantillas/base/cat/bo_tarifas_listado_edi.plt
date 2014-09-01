
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;nuevo_tarifas;%@
<li><a href="?seccion=nuevo_tarifas" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Nou</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return sendForm('modif_tarifas');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Esborrar seleccionats</span></a></li>
</ul></div>

<form name="modif_tarifas" action="?" method="post">
<input type="hidden" name="estado" value="3" />
<table class="full">
<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Primer Descompte</td>
<td class="caption">Segon Descompte</td>
<td class="caption">Quantitat</td>
<td class="caption">Camp acci�</td>
 </tr>
@%where:tabla|Tarifas;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Tarifas.id_tarifa;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_tarifas&id_tarifa=@%db:Tarifas.id_tarifa;%@">@%db:Tarifas.nombre;%@</a></td>
<td> @%db:Tarifas.pto_primero;%@</td>
<td> @%db:Tarifas.pto_segundo;%@ </td>
<td> @%db:Tarifas.monto;%@</td>
<td>
@%if:equals;Tarifas.campo_accion;precio_costo;%@
Preu 1
@%end-if:%@
@%if:equals;Tarifas.campo_accion;precio_standard;%@
Preu 2
@%end-if:%@
@%if:equals;Tarifas.campo_accion;precio_venta;%@
Preu 3
@%end-if:%@
@%if:equals;Tarifas.campo_accion;precio_4;%@
Preu 4
@%end-if:%@
@%if:equals;Tarifas.campo_accion;precio_5;%@
Preu 5
@%end-if:%@
@%if:equals;Tarifas.campo_accion;precio_6;%@
Preu 6
@%end-if:%@
</td>
</tr>
@%end-where:%@

</table>
</form>

@%plt:botonera%@

