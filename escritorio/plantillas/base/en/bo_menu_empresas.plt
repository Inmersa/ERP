@%if:AllowedLink;modif_miempresa;%@
<div class="menuitem"> <a href="?seccion=modif_miempresa" @%func:querystring_activa;modif_miempresa;activo;;%@ >General Information</a></div>
@%end-if:%@
@%if:AllowedLink;bo_contadores;%@
<div class="menuitem"> <a href="?seccion=bo_contadores" @%func:querystring_activa;bo_contadores;activo;;%@ >Meters</a></div>
@%end-if:%@
@%if:AllowedLink;bo_bancos;%@
<div class="menuitem"> <a href="?seccion=bo_bancos" @%func:querystring_activa;bo_bancos;activo;;%@ >Banks</a></div>
@%end-if:%@
@%if:AllowedLink;bo_coordinadores;%@
<div class="menuitem"> <a href="?seccion=bo_coordinadores" @%func:querystring_activa;bo_coordinadores;activo;;%@ >Coordinators</a></div>
@%end-if:%@
@%if:AllowedLink;operadores;%@
<div class="menuitem"><a href="?seccion=operadores" @%func:querystring_activa;operadores;activo;;%@ >Operators</a></div>
@%end-if:%@
@%if:AllowedLink;informe_ventas_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_ventas_detallado" @%func:querystring_activa;informe_ventas_detallado;activo;;%@ >Sales: Detailed Invoicing report</a></div>
@%end-if:%@
@%if:AllowedLink;informe_compras_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_compras_detallado" @%func:querystring_activa;informe_compras_detallado;activo;;%@ >Purchases: Detailed Invoicing report</a></div>
@%end-if:%@
@%if:AllowedLink;informe_producto_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_producto_detallado" @%func:querystring_activa;informe_producto_detallado;activo;;%@ >Sales: Detailed report by product</a></div>
@%end-if:%@
@%if:AllowedLink;informe_producto_compras_detallado;%@
<div class="menuitem"> <a href="?seccion=informe_producto_compras_detallado" @%func:querystring_activa;informe_producto_compras_detallado;activo;;%@ >Purchases: Detailed report by product</a></div>
@%end-if:%@
@%if:AllowedLink;dashboard_tesoreria;%@
<div class="menuitem"> <a href="?seccion=dashboard_tesoreria" @%func:querystring_activa;dashboard_tesoreria;activo;;%@ >Dashboards</a></div>
@%end-if:%@
