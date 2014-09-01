


<form method="post" action="?seccion=hacer_pedido_compra" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_hacer_pedido_compra_search" />

Marque / Famille: <input type="text" name="nombre_marca" size="30" value="@%get:st_nombre_marca%@" />
Article:  <input type="text" name="nombre" size="40" value="@%get:st_nombre%@" />
IDs: <input type="text" name="id" size="10" value="@%get:st_id%@" />

<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="r" class="submit" >Chercher</a></td>
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

