


<div class="tituloseccion">&gt; Inventari de Zona magatzem 
@%if:!esta_vacio;id_almacen_logico_promocion;%@
@%where:tabla|Almacenes_logicos;where|Almacenes_logicos.id_almacen_logico = $id_almacen_logico_promocion;%@
(@%db:Almacenes_logicos.nombre;%@)
@%end-where:%@

@%end-if:%@
</div>

@%plt:Almacen_Logico%@

