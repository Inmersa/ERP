@%if:AllowedLink;modif_articulos;%@
<div class="menuitem"> <a href="?seccion=modif_articulos" @%func:querystring_activa;modif_articulos;activo;;%@ >Datos Generales</a></div>
@%end-if:%@
@%if:AllowedLink;modif_promociones;%@
<div class="menuitem"> <a href="?seccion=modif_promociones" @%func:querystring_activa;modif_promociones;activo;;%@ >Ofer. Promociones</a></div>
@%end-if:%@
@%if:AllowedLink;bo_localizacion_articulos;%@
<div class="menuitem"> <a href="?seccion=bo_localizacion_articulos" @%func:querystring_activa;bo_localizacion_articulos;activo;;%@ >Localizaciones</a></div>
@%end-if:%@
@%if:AllowedLink;bo_cliente_articulos;%@
<div class="menuitem"> <a href="?seccion=bo_cliente_articulos" @%func:querystring_activa;bo_cliente_articulos;activo;;%@ >Clientes Artículo</a></div>
@%end-if:%@
@%if:!esta_vacio;id_articulo;%@
@%if:AllowedLink;dashboard_articulos_venta;%@
<div class="menuitem"><a href="?seccion=dashboard_articulos_venta" @%func:querystring_activa;dashboard_articulos_venta;activo;;%@ >Dashboards</a></div>
@%end-if:%@
@%end-if:%@
