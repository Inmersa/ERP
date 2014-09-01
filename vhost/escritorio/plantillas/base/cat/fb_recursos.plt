
<form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="recursos" />
Buscar Tipus 
<!-- @%set:_selected_value=st[id_tipo];%@ -->
<select name="id_tipo" >
<option value="" >Cap selecció</option>
@%where:Tipos_recurso;nolink|1;order|nombre;%@
<option value="@%db:Tipos_recurso.id_tipo_recurso;%@"
@%db:selected_value{Tipos_recurso.id_tipo_recurso};%@
>@%db:Tipos_recurso.nombre;%@</option>
@%end-where:%@

</select>
Texto <input type="text" name="texto" size="20" value="@%get:st[texto];%@" />
 <a href="#" onClick="return sendForm('buscadorgeneral');" class="submit" accesskey="b" >Buscar</a>

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

