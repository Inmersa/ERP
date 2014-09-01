
@%plt:botonera%@
<table class="full">

<tr><td></td>
<td class="caption">Nom</td>
<td class="caption">Nº Effets</td>
<td class="caption">Jours entre Effets</td>
</tr>
 <form name="modif_forma_pago" action="" method="post">
 <input type="hidden" name="estado" value="3" />


 @%where:tabla|Forma_pago;nombre|busc;%@

<tr>
<td class="check"> <input type="checkbox" name="registro_borrar[@%db:Forma_pago.id_forma_pago;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_forma_pago&id_forma_pago=@%db:Forma_pago.id_forma_pago;%@">@%db:Forma_pago.nombre;%@</a></td>
<td>@%db:Forma_pago.num_efectos;%@</td>
<td>@%db:Forma_pago.dias_efectos;%@</td>
</tr>
@%end-where:%@


</form>
</table>

@%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['modif_forma_pago'].submit();">Elimier</a></div>

