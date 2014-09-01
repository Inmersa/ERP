
<div class="tituloseccion" >
@%if:equals;_krn_ss_name;dashboard_almacenes;%@
Almacenes 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas;%@
Faltas en Venta 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
Faltas en Compra 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
Devoluciones en Venta 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
Devoluciones en Compra 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
Bajas en Almacenes 
@%end-if:%@
[@%func:colocar_fecha;_dsb_fecha;%@]
</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Por Semana (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Por Semana</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Por Mes (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Por Mes</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Por Trimestre (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Por Trimestre</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Por Año (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Por Año</a>
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
><div name="TopMarcas" class="activo" >Faltas en Marca</div
><div name="TopClientes" >Faltas por Cliente</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="TopMarcas" class="activo" >Faltas en Marca</div
><div name="TopProveedores" >Faltas por Proveedor</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="TopMarcas" class="activo" >Devoluciones por Marca</div
><div name="TopClientes" >Devoluciones por Cliente</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="TopMarcas" class="activo" >Devoluciones por Marca</div
><div name="TopProveedores" >Devoluciones por Proveedor</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="TopArticulos" class="activo" >Bajas por Artículo</div
><div name="TopMarcas" >Bajas por Marca</div
><div name="TopClientes" >Bajas por Cliente</div
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
><div name="FaltasVenta" ><a href="?seccion=dashboard_almacenes_faltas" class="cambio_ss" >Faltas en Ventas</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="FaltasCompra" ><a href="?seccion=dashboard_almacenes_faltas_compras" class="cambio_ss" >Faltas en Compras</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_venta" class="cambio_ss" >Devoluciones en Ventas</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_compra" class="cambio_ss" >Devoluciones en Compras</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="Bajas" ><a href="?seccion=dashboard_almacenes_bajas" class="cambio_ss" >Bajas</a></div
@%end-if:%@

></div>

<script >
<!-- 
TabDashboardAlmacenes = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenes'));
TabDashboardAlmacenesExtern = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenesExtern'));
// -->
</script>

