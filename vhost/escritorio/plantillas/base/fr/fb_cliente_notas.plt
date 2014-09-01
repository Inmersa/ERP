
<form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="notas_cliente" />
Chercher Type 
<!-- @%set:_selected_value=st[id_tipo];%@ -->
<select name="id_tipo" >
<option value="" >Aucune sélection</option>
@%where:Tipos_anotacion;nolink|1;order|nombre;%@
<option value="@%db:Tipos_anotacion.id_tipo_anotacion;%@"
@%db:selected_value{Tipos_anotacion.id_tipo_anotacion};%@
>@%db:Tipos_anotacion.nombre;%@</option>
@%end-where:%@

</select>
Text <input type="text" name="texto" size="20" value="@%get:st[texto];%@" />
Date <input type="text" name="fecha_inicio" size="16" 
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
 <a href="#" onClick="return sendForm('buscadorgeneral');" class="submit" accesskey="r" >Chercher</a>

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

