



<form method="post" action="?seccion=bo_agentes" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_agentes_search" />
Text<input type="text" name="nombre" size="20"
 value="@%get:st_nombre;%@" />
<!-- @%set:_selected_value="st_nombre2;%@" -->
<select name="nombre2">
<option value="">Aucune sélection</option>
 @%where:tabla|Tipo_agente;order|nombre;nombre|busc;%@
<option value="@%db:Tipo_agente.id_tipo_agente;%@"
 @%db:selected_value{Tipo_agente.id_tipo_agente};%@
>@%db:Tipo_agente.nombre%@</option>
 @%end-where:%@


</select>
<a href="#" onclick="return sendForm('buscadorgeneral');" class="submit" accesskey="r" >Chercher</a>
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

