
<form method="post" action="?seccion=bo_compra_venta" name="buscadorgeneral">

<input type="hidden" name="nom_bus" value="bo_compra_venta_search" />
<input type="text" name="fecha_inicio" size="12" maxlength="10"
@%if:esta_vacio;fecha_inicio;%@
value="dd/mm/aaaa" 
@%else:%@
value="@%get:st_fecha_inicio;%@"
@%end-if:%@
 />
<input type="text" name="fecha_fin" size="12" maxlength="10"
@%if:esta_vacio;fecha_fin;%@
value="dd/mm/aaaa" 
@%else:%@
value="@%get:st_fecha_fin;%@"
@%end-if:%@
 />
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
