
<div class="buscadorinterior" >
<form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">

<input type="hidden" name="nom_bus" value="bo_hacer_pedido_search" />
Marca / Fam�lia: <input type="text" name="nombre_marca" size="30" value="@%get:st_nombre_marca%@" />
 Artigo / Produto: <input type="text" name="nombre" size="40" value="@%get:st_nombre%@" />
 IDs: <input type="text" name="id" size="10" value="@%get:st_id%@" />

 <a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="p" class="submit" >Pesquisar</a>

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
</div>

