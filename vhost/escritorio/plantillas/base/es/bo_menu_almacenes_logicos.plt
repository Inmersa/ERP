@%if:AllowedLink;modif_almacenes;%@
<div class="menuitem"> <a href="?seccion=modif_almacenes" @%func:querystring_activa;modif_almacenes;activo;;%@ >Datos Generales</a></div>
@%end-if:%@
<!-- 
@%if:AllowedLink;bo_inventario_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_inventario_almacen" @%func:querystring_activa;bo_inventario_almacen;activo;;%@ >Inventario</a></div>
@%end-if:%@
@%if:AllowedLink;bo_albaranes_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_albaranes_almacen" @%func:querystring_activa;bo_albaranes_almacen;activo;;%@ >Histórico de albaranes</a></div>
@%end-if:%@
-->
@%if:AllowedLink;bo_inventario_almacen_logico;%@
<div class="menuitem"> <a href="?seccion=bo_inventario_almacen_logico" @%func:querystring_activa;bo_inventario_almacen_logico;activo;;%@ >Localizaciones</a></div>
@%end-if:%@
@%if:AllowedLink;bo_bajas_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_bajas_almacen" @%func:querystring_activa;bo_bajas_almacen;activo;;%@ >Historico de Bajas</a></div>
@%end-if:%@
