
<form method="post" action="?seccion=bo_inventario_almacen_logico" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_inventario_almacen_logico_search" />
Excluir Baixas
<input type="checkbox" name="excluir_bajas" value="1" @%func:check_flag;st[excluir_bajas];%@ />
<!-- @%set:_selected_value=st[id_alml];%@ -->
<select name="id_alml" >
<option value="" >Todas</option>
@%where:tabla|Almacenes_logicos;nolink|1;order|nombre;where|id_almacen = $id_almacen_promocion;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@"
@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
>@%db:Almacenes_logicos.nombre;%@</option>
@%end-where:%@

</select>
 IDs<input type="text" name="id_art" class="mininum" value="@%get:st[id_art];%@" />
 Texto<input type="text" name="nombre" size="20" value="@%get:st[nombre];%@" />
 Código de Barras<input type="text" name="cod_barras" size="20" value="@%get:st[cod_barras];%@" />
 <br/>
 <input type="text" name="fecha_inicio" class="fecha" 
 @%if:esta_vacio;st[fecha_inicio];%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st[fecha_inicio];%@"
 @%end-if:%@
 />
 <input type="text" name="fecha_fin" class="fecha" 
 @%if:esta_vacio;st[fecha_fin];%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st[fecha_fin];%@"
 @%end-if:%@
 />
 Quantidade de <input type="text" name="cantidad_inicio" class="mininum" value="@%get:st[cantidad_inicio];%@" />
 a <input type="text" name="cantidad_fin" class="mininum" value="@%get:st[cantidad_fin];%@" />
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

