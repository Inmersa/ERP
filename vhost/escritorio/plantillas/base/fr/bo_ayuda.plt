<div class="barraoscura">
<div class="titsuperior">&gt; Aide</div><div class="alinder">
<a href="?seccion=bo_ayuda_nuevo">Nouveau</a>
</div></div> 

<form name="modif_ayuda" action="?seccion=bo_ayuda" method="post">
<input type="hidden" name="estado" value="2" />
<table class="full">
<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Titre</td>
<td class="caption">Sous-section</td>
</tr>
@%where:tabla|Ayuda;nombre|busc;no_results|1;%@
<!-- @%set:id_sub = Ayuda.id_sub;%@ -->
<tr>
<td class="check"><input type="checkbox" name="registro_borrar[@%db:Ayuda.id_sub;%@]" value="1" /></td>
<td class="etiqueta"><a href="?seccion=bo_ayuda_modif&id_sub=@%db:Ayuda.id_sub;%@">@%db:Ayuda.nombre;%@</a></td>
<td> @%db:Ayuda.titulo;%@</td>
<td>
@%where:nombre|ss;nolink|1;db|conf;where|id_sub_secc = $id_sub;%@
@%db:Sub_Secc.nombre_visual;%@
@%end-where:%@

</td>
</tr>
@%end-where:%@

</table>
</form>

@%plt:botonera%@
<div class="enviar"><a href="#" onClick="return sendForm('modif_ayuda');">Elimier</a></div>
