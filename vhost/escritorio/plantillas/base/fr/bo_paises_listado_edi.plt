@%plt:botonera%@

<table class="full">

<tr>
<td></td>
<td class="caption">Nom</td>
<td class="caption">Code</td>
<td class="caption">Continent</td>
<td class="caption">Prefixe Tf.</td>
<td class="caption">Prefixe NSF</td>

 </tr>
 <form name="modif_paises" action="" method="post">
 <input type="hidden" name="estado" value="3" />


 @%where:tabla|Paises;nombre|busc;%@
<tr>
<td class="check"> <input type="checkbox" name="registro_borrar[@%db:Paises.id_pais;%@]" value="1" /></td>
<td class="etiqueta"> <a href="?seccion=modif_paises&id_pais=@%db:Paises.id_pais;%@">@%db:Paises.nombre;%@ </a></td>
<td>@%db:Paises.codigo;%@</td>
<td>@%db:Paises.continente;%@</td>
<td>@%db:Paises.prefijo_tlf;%@</td>
<td>@%db:Paises.prefijo_cif;%@</td>
</tr>

 @%end-where:%@


</table>
@%plt:botonera%@
<div class="enviar"><a href="javascript:document.forms['modif_paises'].submit();">Elimier</a></div>

</form>