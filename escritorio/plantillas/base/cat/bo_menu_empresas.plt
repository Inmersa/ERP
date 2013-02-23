@%if:AllowedLink;modif_miempresa;%@
<div class="menuitem"> <a href="?seccion=modif_miempresa" @%func:querystring_activa;modif_miempresa;activo;;%@ >Dades generals</a></div>
@%end-if:%@
@%if:AllowedLink;bo_contadores;%@
<div class="menuitem"> <a href="?seccion=bo_contadores" @%func:querystring_activa;bo_contadores;activo;;%@ >Comptador</a></div>
@%end-if:%@
@%if:AllowedLink;bo_bancos;%@
<div class="menuitem"> <a href="?seccion=bo_bancos" @%func:querystring_activa;bo_bancos;activo;;%@ >Bancs</a></div>
@%end-if:%@
@%if:AllowedLink;bo_coordinadores;%@
<div class="menuitem"> <a href="?seccion=bo_coordinadores" @%func:querystring_activa;bo_coordinadores;activo;;%@ >Coordinadors</a></div>
@%end-if:%@
@%if:AllowedLink;operadores;%@
<div class="menuitem"><a href="?seccion=operadores" @%func:querystring_activa;operadores;activo;;%@ >Operadors</a></div>
@%end-if:%@
@%if:AllowedLink;informe_ventas_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_ventas_detallado" @%func:querystring_activa;informe_ventas_detallado;activo;;%@ >Informe Detallat de Facturació en Vendes</a></div>
@%end-if:%@
@%if:AllowedLink;informe_compras_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_compras_detallado" @%func:querystring_activa;informe_compras_detallado;activo;;%@ >Informe Detallat de Facturació en Compres</a></div>
@%end-if:%@
@%if:AllowedLink;informe_producto_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_producto_detallado" @%func:querystring_activa;informe_producto_detallado;activo;;%@ >Informe Detallat de Vendes per producte</a></div>
@%end-if:%@
@%if:AllowedLink;informe_producto_compras_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_producto_compras_detallado" @%func:querystring_activa;informe_producto_compras_detallado;activo;;%@ >Informe Detallat de Compres per producte</a></div>
@%end-if:%@
@%if:AllowedLink;dashboard_tesoreria;%@
<div class="menuitem"> <a href="?seccion=dashboard_tesoreria" @%func:querystring_activa;dashboard_tesoreria;activo;;%@ >Dashboards</a></div>
@%end-if:%@
