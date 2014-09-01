
<form method="post" action="?seccion=bo_unidades_medida" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_unidades_medida_search" />
Texto<input type="text" name="nombre" class="texto" value="@%get:st_nombre;%@" />
 <a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="p" class="submit">Pesquisar</a>
<select name="hp">
@%where:nodb|nodb_hits_page;%@
<option value="@%db:value;%@"
@%if:equals;st_hp;value;%@
selected="selected"
@%end-if:%@
>@%db:name;%@</option>
@%end-where:%@

</select>
</form>

