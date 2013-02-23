
<form method="post" action="?seccion=operadores" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="operadores" />
Text<input type="text" name="texto" value="@%get:st[nombre];%@" />

<a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="r" >Chercher</a>
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
