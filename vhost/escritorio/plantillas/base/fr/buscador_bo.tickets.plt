
 <form method="post" action="?seccion=ticket_list" name="buscadorgeneral">

 <input type="hidden" name="nom_bus" value="bo_pedidos_ventas_search" />
 Text<input type="text" name="nombre" size="20" value="@%get:st_nombre;%@" />
<select name="preparado">
<option value="">---------------</option>
<option value="1"
@%if:equals;st_preparado;1;%@
selected="selected"
@%end-if:%@
>Pr�t</option>
<option value="0"
@%if:equals;st_preparado;0;%@
selected="selected"
@%end-if:%@
>Sans Pr�t</option>
</select>
 <input type="text" name="fecha_inicio" value="dd/mm/aaaa" size="12"
 @%if:esta_vacio;st_fecha_inicio;%@
 value="dd/mm/aaaa"
 @%else:%@
 value="@%get:st_fecha_inicio;%@"
 @%end-if:%@
 />
 <input type="text" name="fecha_fin" size="12"
 @%if:esta_vacio;st_fecha_fin;%@
 value="dd/mm/aaaa"
 @%else:%@
 value="@%get:st_fecha_fin;%@"
 @%end-if:%@
 />
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
