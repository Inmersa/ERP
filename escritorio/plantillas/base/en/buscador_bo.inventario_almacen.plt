
<form method="post" action="?seccion=bo_inventario_almacen" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="bo_inventario_almacen_search" />
To exclude outdated
<input type="checkbox" name="excluir_bajas" value="1" @%func:check_flag;st[excluir_bajas];%@ />
 <select name="precio">
 <option value="precio_costo"
 @%if:equals;st[precio];precio_costo;%@
 selected="selected" 
 @%end-if:%@
 >Price 1</option>
 <option value="precio_standard"
 @%if:equals;st[precio];precio_standard;%@
 selected="selected" 
 @%end-if:%@
 >Price 2</option>
 <option value="precio_venta"
 @%if:equals;st[precio];precio_venta;%@
 selected="selected" 
 @%end-if:%@
 >Price 3</option>
 <option value="precio_4"
 @%if:equals;st[precio];precio_4;%@
 selected="selected" 
 @%end-if:%@
 >Price 4</option>
 <option value="precio_5"
 @%if:equals;st[precio];precio_5;%@
 selected="selected" 
 @%end-if:%@
 >Price 5</option>
 <option value="precio_6"
 @%if:equals;st[precio];precio_6;%@
 selected="selected" 
 @%end-if:%@
 >Price 6</option>
 </select>
<!-- @%set:_selected_value=st[id_alml];%@ -->
<select name="id_alml" >
<option value="" >All</option>
<option value="-1" 
@%if:equals;_selected_value;-1;%@
selected="selected"
@%end-if:%@
>None</option>
@%where:tabla|Almacenes_logicos;nolink|1;order|nombre;where|id_almacen = $id_almacen_promocion;%@
<option value="@%db:Almacenes_logicos.id_almacen_logico;%@"
@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
>@%db:Almacenes_logicos.nombre;%@</option>
@%end-where:%@

</select>
 IDs<input type="text" name="id_art" class="mininum" value="@%get:st[id_art];%@" />
 Text<input type="text" name="nombre" size="20" value="@%get:st[nombre];%@" />
 Bar code<input type="text" name="cod_barras" size="20" value="@%get:st[cod_barras];%@" />
 <br/>
 <input type="text" name="fecha_inicio" class="fecha" 
 @%if:esta_vacio;st[fecha_inicio];%@
 value="dd/mm/yyyy" 
 @%else:%@
 value="@%get:st[fecha_inicio];%@"
 @%end-if:%@
 />
 <input type="text" name="fecha_fin" class="fecha" 
 @%if:esta_vacio;st[fecha_fin];%@
 value="dd/mm/yyyy" 
 @%else:%@
 value="@%get:st[fecha_fin];%@"
 @%end-if:%@
 />
 Amount of <input type="text" name="cantidad_inicio" class="mininum" value="@%get:st[cantidad_inicio];%@" />
 to <input type="text" name="cantidad_fin" class="mininum" value="@%get:st[cantidad_fin];%@" />
 <a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="f" class="submit">Search</a>
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

