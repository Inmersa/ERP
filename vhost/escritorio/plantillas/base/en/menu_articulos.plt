@%if:AllowedLink;bo_articulos;%@
<div class="menuitem"> <a href="?seccion=bo_articulos" @%func:querystring_activa;bo_articulos;activo;;%@ >Articles</a></div>
@%end-if:%@
@%if:AllowedLink;bo_marcas;%@
<div class="menuitem"> <a href="?seccion=bo_marcas" @%func:querystring_activa;bo_marcas;activo;;%@ >Brands</a></div>
@%end-if:%@
@%if:!esta_vacio;id_marca;%@
@%if:AllowedLink;dashboard_marcas;%@
<div class="menuitem"><a href="?seccion=dashboard_marcas" @%func:querystring_activa;dashboard_marcas;activo;;%@ >Dashboards Brands</a></div>
@%end-if:%@
@%end-if:%@
