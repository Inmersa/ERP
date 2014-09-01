
<form method="post" action="?seccion=bo_bajas_almacen" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_bajas_almacen_search" />

<!-- @%set:_selected_value=st_id_alml;%@ -->
<select name="id_alml" >
<option value="" >Tout</option>
@%where:tabla|Almacenes_logicos;nolink|1;order|nombre;where|id_almacen = $id_almacen_promocion;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@"
@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
>@%db:Almacenes_logicos.nombre;%@</option>
@%end-where:%@

</select>

<!-- @%set:_selected_value="st_id_baja;%@" -->
<select name="id_baja">
<option value="">Tout</option>
@%where:tabla|Bajas_almacen;nolink|1;%@
<option value="@%db:Bajas_almacen.id_baja_almacen;%@"
@%db:selected_value{Bajas_almacen.id_baja_almacen};%@
>@%db:Bajas_almacen.nombre;%@</option>
@%end-where:%@

</select>
Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
<input type="text" name="fecha_inicio" size="12" maxlength="10" 
@%if:esta_vacio;st_fecha_inicio;%@
value="dd/mm/aaaa"
@%else:%@
value="@%get:st_fecha_inicio;%@"
@%end-if:%@
>
<input type="text" name="fecha_fin" size="12" maxlength="10" 
@%if:esta_vacio;st_fecha_fin;%@
value="dd/mm/aaaa"
@%else:%@
value="@%get:st_fecha_fin;%@"
@%end-if:%@
>
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
