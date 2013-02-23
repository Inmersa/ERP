@%plt:botonera%@
<table class="full">

<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Pourcentage</td>
<td class="caption">Reteneu équivalent</td>
 </tr>
 <form name="modif_tipos_iva" action="" method="post">
 <input type="hidden" name="estado" value="3" />
 @%where:tabla|Tipos_IVA;nombre|busc;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Tipos_IVA.id_iva;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_tipos_iva&id_iva=@%db:Tipos_IVA.id_iva;%@">@%db:Tipos_IVA.nombre;%@ </a></td>
<td>@%db:Tipos_IVA.porcentaje;%@</td>
<td>@%db:Tipos_IVA.recargo_equivalente;%@ </td>
 </tr>
@%end-where:%@

</form>
</table>
@%plt:botonera%@
<div class="enviar"><a href="#" onClick="return sendForm('modif_tipos_iva');">Elimier</a></div>
