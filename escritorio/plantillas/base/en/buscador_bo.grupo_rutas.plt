
 <form method="post" action="#" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="grupo_rutas_search" />
 Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
 <a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="f" >Search</a>
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
