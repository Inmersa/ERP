@%plt:botonera%@
<table class="full">

<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Descripció</td>
</tr>

<form name="modif_grupo_rutas" action="" method="post">
<input type="hidden" name="estado" value="3" />
@%where:tabla|Grupo_rutas;nombre|busc;no_results|1;%@
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Grupo_rutas.id_grupo_ruta;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=modif_grupo_rutas&id_grupo_ruta=@%db:Grupo_rutas.id_grupo_ruta;%@">@%db:Grupo_rutas.nombre;%@</a></td>
<td>@%db:Grupo_rutas.descripcion;%@</td>
 </tr>
@%end-where:%@

<tr>
 </table>
</form>
@%plt:botonera%@
<div class="enviar"><a href="#" onClick="return sendForm('modif_grupo_rutas');">Esborrar seleccionats</a></div>

