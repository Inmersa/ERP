
<div class="tituloseccion" >
@%if:equals;_krn_ss_name;dashboard_almacenes;%@
Warehouses 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas;%@
Sales Failures 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
Purchases Failures 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
Sales Returns 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
Purchases Returns 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
Warehouses Stock Downs 
@%end-if:%@
[@%func:colocar_fecha;_dsb_fecha;%@]
</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Per Week (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Per Week</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Per Month (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Per Month</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Per Trimester (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Per Trimester</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Per Year (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Per Year</a>
@%end-if:%@
</div></div>


<div class="PIIFichaBase" id="Indicadores_Generales" >
@%plt:IndicadoresGenerales;%@
</div>

<div class="PIIContainer" id="FichaTab_DashboardAlmacenes" 
@%if:equals;_krn_ss_name;dashboard_almacenes;%@
@%if:AllowedPII;Stock;%@
><div name="Stock" class="activo" >Stock</div
@%end-if:%@
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_faltas;%@
><div name="TopMarcas" class="activo" >Brands Failures</div
><div name="TopClientes" >Client Failures</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="TopMarcas" class="activo" >Brands Failures</div
><div name="TopProveedores" >Supplier Failures</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="TopMarcas" class="activo" >Returns by Brand</div
><div name="TopClientes" >Returns by Client</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="TopMarcas" class="activo" >Returns by Brand</div
><div name="TopProveedores" >Returns by Supplier</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="TopArticulos" class="activo" >Stock Down by Article</div
><div name="TopMarcas" >Stock Down by Brand</div
><div name="TopClientes" >Stock Down by Client</div
@%end-if:%@

></div>

@%if:AllowedPII;Stock;%@
<div class="PIIFicha" id="Stock" >
@%plt:Stock;%@
</div>
@%end-if:%@

@%if:AllowedPII;TopArticulos;%@
<div class="PIIFicha" id="TopArticulos" >
@%plt:TopArticulos;%@
</div>
@%end-if:%@

@%if:AllowedPII;TopMarcas;%@
<div class="PIIFicha" id="TopMarcas" >
@%plt:TopMarcas;%@
</div>
@%end-if:%@

@%if:AllowedPII;TopClientes;%@
<div class="PIIFicha" id="TopClientes" >
@%plt:TopClientes;%@
</div>
@%end-if:%@

@%if:AllowedPII;TopProveedores;%@
<div class="PIIFicha" id="TopProveedores" >
@%plt:TopProveedores;%@
</div>
@%end-if:%@

<div class="PIIContainer" id="FichaTab_DashboardAlmacenesExtern" 
@%if:!equals;_krn_ss_name;dashboard_almacenes;%@
><div name="Stock" ><a href="?seccion=dashboard_almacenes" class="cambio_ss" >Stock</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_faltas;%@
><div name="FaltasVenta" ><a href="?seccion=dashboard_almacenes_faltas" class="cambio_ss" >Sales Failures</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="FaltasCompra" ><a href="?seccion=dashboard_almacenes_faltas_compras" class="cambio_ss" >Purchases Failures</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_venta" class="cambio_ss" >Returns in Sales</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_compra" class="cambio_ss" >Returns in Purchases</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="Bajas" ><a href="?seccion=dashboard_almacenes_bajas" class="cambio_ss" >Stock Downs</a></div
@%end-if:%@

></div>

<script >
<!-- 
TabDashboardAlmacenes = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenes'));
TabDashboardAlmacenesExtern = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenesExtern'));
// -->
</script>

