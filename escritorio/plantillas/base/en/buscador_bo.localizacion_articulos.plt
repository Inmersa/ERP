

<form method="post" action="?seccion=bo_localizacion_articulos" name="buscadorgeneral">

<input type="hidden" name=nom_bus value=bo_localizacion_articulos_search>
Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@">
<input type=submit name=Buscar value="Buscar">
<a href="#" href="return sendForm('buscadorgeneral');" class="submit" accesskey="f" >Search</a>
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

