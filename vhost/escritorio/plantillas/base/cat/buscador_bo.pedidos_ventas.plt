
 <form method="post" action="?seccion=bo_pedidos_ventas" name="buscadorgeneral">

 <input type="hidden" name="nom_bus" value="bo_pedidos_ventas_search" />
Comandes Residuals <input type="checkbox" name="residuales" value="1" @%func:check_flag;st[residuales];%@ />
Excloure Comandes Residuals <input type="checkbox" name="sin_residuales" value="1" @%func:check_flag;st[sin_residuales];%@ />
Excloure Consolidats <input type="checkbox" name="sin_consolidados" value="1" @%func:check_flag;st[sin_consolidados];%@ />
 Ref.<input type="text" name="ref" size="20" value="@%get:st[ref];%@" />

 <br/>
 Ra� social<input type="text" name="razons" size="20" value="@%get:st[razons];%@" />
 Texto<input type="text" name="nombre" size="20" value="@%get:st[nombre];%@" />
<select name="preparado">
<option value="">---------------</option>
<option value="1"
@%if:equals;st[preparado];1;%@
selected="selected"
@%end-if:%@
>Preparat</option>
<option value="0"
@%if:equals;st[preparado];0;%@
selected="selected"
@%end-if:%@
>Sense Preparat</option>
</select>
 <input type="text" name="fecha_inicio" size="12"
 @%if:esta_vacio;st[fecha_inicio];%@
 value="dd/mm/aaaa"
 @%else:%@
 value="@%get:st[fecha_inicio];%@"
 @%end-if:%@
 />
 <input type="text" name="fecha_fin" size="12"
 @%if:esta_vacio;st[fecha_fin];%@
 value="dd/mm/aaaa"
 @%else:%@
 value="@%get:st[fecha_fin];%@"
 @%end-if:%@
 />
<a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="b" class="submit">Buscar</a>
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
