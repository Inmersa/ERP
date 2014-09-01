
@%plt:botonera%@

<div id="AccionesListado"><ul>
@%if:AllowedLink;nuevo_familia_articulos;%@
<li><a href="?seccion=nuevo_familia_articulos" class="accesos" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span> Nouveau</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return sendForm('modif_familia_articulos');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
</ul></div>

<form name="modif_familia_articulos" action="" method="post">
 <input type="hidden" name="estado" value="3" />
<table class="full">
<thead>
<tr>
<td></td>
<td class="caption">Nom famille</td>
</tr>
</thead>
<tbody>
@%where:tabla|Familia_articulos;nombre|busc;%@
<tr>
<td class="check"> <input type="checkbox" name="registro_borrar[@%db:Familia_articulos.id_familia;%@]" value="1" /></td>
<td><a href="?seccion=modif_familia_articulos&id_familia=@%db:Familia_articulos.id_familia;%@">@%db:Familia_articulos.nombre;%@</a></td>
</tr>
@%end-where:%@

</tbody>
</table>
</form>

@%plt:botonera%@


