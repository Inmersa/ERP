
<form method="post" action="?seccion=cliente_servicios" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="servicios_cliente" />
Busca pelo tipo 
<!-- @%set:_selected_value=st[id_tipo];%@ -->
<select name="id_tipo" >
<option value="" >Não Existem Itens Seleccionados</option>
@%where:Tipos_recurso;nolink|1;order|nombre;%@
<option value="@%db:Tipos_recurso.id_tipo_recurso;%@"
@%db:selected_value{Tipos_recurso.id_tipo_recurso};%@
>@%db:Tipos_recurso.nombre;%@</option>
@%end-where:%@

</select>
Texto <input type="text" name="texto" size="20" value="@%get:st[texto];%@" />
Data de Início <input type="text" name="fecha_inicio" size="16" 
@%if:esta_vacio;st[fecha_inicio];%@
value="dd/mm/aaaa"
@%else:%@
value="@%get:st[fecha_inicio];%@" 
@%end-if:%@
/>
<input type="text" name="fecha_fin" size="16" 
@%if:esta_vacio;st[fecha_fin];%@
value="dd/mm/aaaa"
@%else:%@
value="@%get:st[fecha_fin];%@" 
@%end-if:%@
/>
 <a href="#" onClick="return sendForm('buscadorgeneral');" class="submit" accesskey="p" >Pesquisar</a>

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

