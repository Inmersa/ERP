
<form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="tipos_anotacion" />
Text <input type="text" name="texto" size="20" value="@%get:st[texto];%@" />
 <a href="#" onClick="return sendForm('buscadorgeneral');" class="submit" accesskey="f" >Search</a>

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

