
 <form method="post" action="?seccion=bo_proveedores" name="buscadorgeneral">
 <input type="hidden" name="nom_bus" value="bo_proveedores_search" />
 Texto<input type="text" name="nombre" value="@%get:st_nombre;%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="b"  class="submit" >Buscar</a>
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
