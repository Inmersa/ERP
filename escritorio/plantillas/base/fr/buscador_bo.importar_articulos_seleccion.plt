
<form method="post" action="?seccion=bo_importar_articulos_seleccion" name="buscadorgeneral">
 <input type="hidden" name="nom_bus" value="bo_importar_articulos_seleccion_search" />
 IDs : <input type="text" name="idarticulo" size="20" value="@%get:st_idarticulo;%@" />
 Text<input type="text" name="nombre" value="@%get:st_nombre;%@" />
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
