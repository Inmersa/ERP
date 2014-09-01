
@%plt:botonera%@

<div id="AccionesListado" ><ul>
@%if:AllowedLink;nuevo_divisa;%@
<li><a href="?seccion=nuevo_divisa" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Novo</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return sendForm('modif_divisa');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
</ul></div>

<table class="full">

<tr>
<td></td>
<td class="caption">Nome</td>
<td class="caption">Legenda</td>
<td class="caption">Ratio</td>
</tr>

 <form name="modif_divisa" action="" method="post">
 <input type="hidden" name="estado" value="3" />

@%where:tabla|Divisa;nombre|busc;%@
<tr><td class="check"><input type="checkbox" name="registro_borrar[@%db:Divisa.id_divisa;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_divisa&id_divisa=@%db:Divisa.id_divisa;%@">@%db:Divisa.nombre;%@</a></td>
<td>@%db:Divisa.leyenda;%@</td>
<td>@%db:Divisa.ratio;%@</td>
</tr>

@%end-where:%@


</form>
</table>

@%plt:botonera%@

