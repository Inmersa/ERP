
@%plt:botonera%@

<div id="AccionesEncabezado"><ul>
@%if:AllowedLink;nuevo_grupo_familias;%@
<li><a href="?seccion=nuevo_grupo_familias" class="accesos" class="nuevo" ><img src="imag/pixel.png" class="icono" /><span>Nouveau</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return sendForm('modif_grupo_familias');" class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
</ul></div>

<form name="modif_grupo_familias" action="#" method="post">
<input type="hidden" name=estado value="3" />

<table class="full">
<thead>
<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Description</td>
</tr>
</thead>

<tbody>
@%where:tabla|Grupo_familias;nombre|busc;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Grupo_familias.id_grupo_familia;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_grupo_familias&id_grupo_familia=@%db:Grupo_familias.id_grupo_familia;%@">@%db:Grupo_familias.nombre;%@</a></td>
<td>@%db:Grupo_familias.descripcion;%@</td>
</tr>
@%end-where:%@

</tbody>
</table>
</form>

@%plt:botonera%@

