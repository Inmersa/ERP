
 <form method="post" action="?seccion=bo_importar_articulos_proveedor" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_articulos_proveedor_search" />
Marque / Famille<input type="text" name="marca" size="20" value="@%get:st_marca;%@" />
IDs<input type="text" name="ida" size="10" value="@%get:st_ida%@" />
 Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
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
