
<div class="tituloseccion" >
@%if:equals;_krn_ss_name;dashboard_almacenes;%@
Magatzems 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas;%@
Faltes en Venda 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
Faltes en Compra 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
Devolucions en Venda 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
Devolucions en Compra 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
Baixes en Magatzems 
@%end-if:%@
[@%func:colocar_fecha;_dsb_fecha;%@]
</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Per Setmana (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Per Setmana</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Per Mes (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Per Mes</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Per Trimestre (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Per Trimestre</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Per Any (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Per Any</a>
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
><div name="TopMarcas" class="activo" >Faltes en Marca</div
><div name="TopClientes" >Faltes en Client</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="TopMarcas" class="activo" >Faltes en Marca</div
><div name="TopProveedores" >Faltes en Proveïdor</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="TopMarcas" class="activo" >Devolucions per Marca</div
><div name="TopClientes" >Devolucions per Client</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="TopMarcas" class="activo" >Devolucions per Marca</div
><div name="TopProveedores" >Devolucions per Proveïdor</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="TopArticulos" class="activo" >Baixes per Article</div
><div name="TopMarcas" >Baixes per Marca</div
><div name="TopClientes" >Baixes per Client</div
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
><div name="FaltasVenta" ><a href="?seccion=dashboard_almacenes_faltas" class="cambio_ss" >Faltes en Vendes</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="FaltasCompra" ><a href="?seccion=dashboard_almacenes_faltas_compras" class="cambio_ss" >Faltes en Compres</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_venta" class="cambio_ss" >Devolucions en Vendes</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_compra" class="cambio_ss" >Devolucions en Compres</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="Bajas" ><a href="?seccion=dashboard_almacenes_bajas" class="cambio_ss" >Baixes</a></div
@%end-if:%@

></div>

<script >
<!-- 
TabDashboardAlmacenes = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenes'));
TabDashboardAlmacenesExtern = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenesExtern'));
// -->
</script>

