@%if:AllowedLink;modif_almacenes;%@
<div class="menuitem"> <a href="?seccion=modif_almacenes" @%func:querystring_activa;modif_almacenes;activo;;%@ >Informações Gerais</a></div>
@%end-if:%@
@%if:AllowedLink;bo_inventario_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_inventario_almacen&_chgsm=1" @%func:querystring_activa;bo_inventario_almacen&_chgsm;activo;;%@ >Inventário</a></div>
@%end-if:%@
@%if:AllowedLink;bo_albaranes_compra;%@
<div class="menuitem"><a href="?seccion=bo_albaranes_compra" @%func:querystring_activa;bo_albaranes_compra;activo;;%@ >Guias de Remessa Compras</a></div>
@%end-if:%@
@%if:AllowedLink;bo_albaranes_venta;%@
<div class="menuitem"><a href="?seccion=bo_albaranes_venta" @%func:querystring_activa;bo_albaranes_venta;activo;;%@ >Guias de Remessa Vendas</a></div>
@%end-if:%@
@%if:AllowedLink;bo_inventario_almacen_logico;%@
<div class="menuitem"> <a href="?seccion=bo_inventario_almacen_logico" @%func:querystring_activa;bo_inventario_almacen_logico;activo;;%@ >Localizações</a></div>
@%end-if:%@
@%if:AllowedLink;bo_bajas_almacen;%@
<div class="menuitem"> <a href="?seccion=bo_bajas_almacen" @%func:querystring_activa;bo_bajas_almacen;activo;;%@ >Histórico de Saídas</a></div>
@%end-if:%@
@%if:AllowedLink;modif_almacenes_logicos;%@
	@%if:!esta_vacio;id_almacen;%@
	@%where:tabla|Almacenes_logicos;where|Almacenes.id_almacen = $id_almacen;%@
	<!-- @%db:Almacenes.id_almacen;%@"-->
	<div class="menuitem" ><a href="?seccion=modif_almacenes_logicos&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@&_chgsm=1" 
	@%func:querystring_activa;modif_almacenes_logicos&id_almacen_logico;activo;;%@ >@%db:Almacenes_logicos.nombre;%@</a></div>
	@%end-where:%@

	@%end-if:%@
@%end-if:%@
@%if:AllowedLink;dashboard_almacenes;%@
<div class="menuitem"><a href="?seccion=dashboard_almacenes" @%func:querystring_activa;dashboard_almacenes;activo;;%@ >Dashboards</a></div>
@%end-if:%@
