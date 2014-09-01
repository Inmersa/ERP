

<form method="post" action="?seccion=bo_articulos" name="buscadorgeneral" >
<input type="hidden" name="nom_bus" value="bo_articulos_search" />
Texto<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
IDs<input type="text" name="id" size="10" value="@%get:st_id%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="b" >Buscar</a>

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

