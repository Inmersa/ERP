
<form method="post" action="?seccion=bo_descuento_articulos" name="buscadorgeneral">

<input type="hidden" name=nom_bus value="bo_articulos_descuento_search" />
  IDs: <input type=text name="id_art" size="20" value="@%get:st_id_art;%@">
Texto<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="p" >Pesquisar</a>
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

