
<form method="post" action="?seccion=bo_compra_articulos_proveedores" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_compra_articulos_search" />
Excluir Baixas <input type="checkbox" name="excluir_bajas" value="1" @%func:check_flag;st[excluir_bajas];%@ />
Marca / Fam�lia<input type="text" name="marca" size="20" value="@%get:st[marca];%@" />
IDs<input type="text" name="ida" size="10" value="@%get:st[ida]%@" />
Texto<input type="text" name="nombre" size="20" value="@%get:st[nombre];%@" />
<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="p" class="submit">Pesquisar</a>
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

