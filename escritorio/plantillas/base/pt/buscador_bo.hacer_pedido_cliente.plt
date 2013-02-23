
<form method="post" action="?seccion=@%get:ss_nm;%@" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_hacer_pedido_cliente_search" />
 ID<input type="text" name="id_cli" class="ids" value="@%get:st_id_cli;%@" />
 Texto<input type="text" name="nombre" class="search" value="@%get:st_nombre;%@" />
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

