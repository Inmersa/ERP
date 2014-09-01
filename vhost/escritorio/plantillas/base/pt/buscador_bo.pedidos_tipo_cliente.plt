
 <form method="post" action="?seccion=bo_pedidos_tipo_cliente" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_pedidos_tipo_cliente_search" />
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
