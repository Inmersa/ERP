
<form method="post" action="?seccion=cfg_anyos" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="anyos_search" />
Text<input type="text" name="texto" class="texto" value="@%get:st[texto];%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="r" class="submit">Chercher</a>
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

