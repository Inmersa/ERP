@%if:AllowedLink;modif_agentes;%@
<div class="menuitem"> <a href="?seccion=modif_agentes" @%func:querystring_activa;modif_agentes;activo;;%@ >General Information</a></div>
@%end-if:%@
@%if:AllowedLink;bo_pedidos_agentes;%@
<div class="menuitem"> <a href="?seccion=bo_pedidos_agentes" @%func:querystring_activa;bo_pedidos_agentes;activo;;%@ >All time orders record</a></div>
@%end-if:%@
@%if:AllowedLink;bo_facturas_agente;%@
<div class="menuitem"> <a href="?seccion=bo_facturas_agente" @%func:querystring_activa;bo_facturas_agente;activo;;%@ >All time invoices record</a></div>
@%end-if:%@
@%if:AllowedLink;bo_agentes_clientes;%@
<div class="menuitem"> <a href="?seccion=bo_agentes_clientes" @%func:querystring_activa;bo_agentes_clientes;activo;;%@ >Clients-Agents</a></div>
@%end-if:%@
@%if:AllowedLink;bo_informe_agentes_clientes;%@
<div class="menuitem"> <a href="?seccion=bo_informe_agentes_clientes" @%func:querystring_activa;bo_informe_agentes_clientes;activo;;%@ >Invoices Report</a></div>
@%end-if:%@
@%if:AllowedLink;bo_recorridos;%@
<div class="menuitem"> <a href="?seccion=bo_recorridos" @%func:querystring_activa;bo_recorridos;activo;;%@ >Day Works</a></div>
@%end-if:%@
@%if:AllowedLink;dashboard_agentes;%@
<div class="menuitem"><a href="?seccion=dashboard_agentes" @%func:querystring_activa;dashboard_agentes;activo;;%@ >Dashboards</a></div>
@%end-if:%@
