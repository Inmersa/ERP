@%if:AllowedLink;modif_almacenes;%@
<div class="menuitem"> <a href="?seccion=modif_almacenes" @%func:querystring_activa;modif_almacenes;activo;;%@ >Informações Gerais</a></div>
@%end-if:%@
<!-- 
@%if:AllowedLink;bo_inventario_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_inventario_almacen" @%func:querystring_activa;bo_inventario_almacen;activo;;%@ >Inventário</a></div>
@%end-if:%@
@%if:AllowedLink;bo_albaranes_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_albaranes_almacen" @%func:querystring_activa;bo_albaranes_almacen;activo;;%@ >Histórico de Guias de Remessa</a></div>
@%end-if:%@
-->
@%if:AllowedLink;bo_inventario_almacen_logico;%@
<div class="menuitem"> <a href="?seccion=bo_inventario_almacen_logico" @%func:querystring_activa;bo_inventario_almacen_logico;activo;;%@ >Localizações</a></div>
@%end-if:%@
@%if:AllowedLink;bo_bajas_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_bajas_almacen" @%func:querystring_activa;bo_bajas_almacen;activo;;%@ >Histórico de Saídas</a></div>
@%end-if:%@
