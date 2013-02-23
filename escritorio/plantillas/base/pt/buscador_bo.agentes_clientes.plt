
<form method="post" action="" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_agentes_clientes_search" />
Excluir Baixas<input type="checkbox" name="excluir_bajas" value="1" @%func:check_flag;st[excluir_bajas];%@ />
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
