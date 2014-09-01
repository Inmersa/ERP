
<div class="tituloseccion" >
@%if:!equals;_krn_ss_name;dashboard_articulos_compra;%@
Sales by Article 
@%else:%@
Purchases by Article 
@%end-if:%@
[@%func:colocar_fecha;_dsb_fecha;%@]
@%if:!esta_vacio;id_articulo;%@
@%where:tabla|Articulos;where|Articulos.id_articulo = $id_articulo;nolink|1;%@
@%db:Articulos.nombre;%@
@%end-where:%@

@%end-if:%@
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

<div class="PIIContainer" id="FichaTab_DashboardArticulos" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;IndicadoresComparados;%@
><div name="IndicadoresComparados" class="activo" >Compared Values</div
@%end-if:%@
@%if:AllowedPII;PedidosComparados;%@
><div name="PedidosComparados" 
@%if:equals;_krn_ss_name;dashboard_articulos_servidoventa;%@
class="activo"
@%end-if:%@
>Compared Orders</div
@%end-if:%@
@%if:AllowedPII;ServidoComparados;%@
><div name="ServidoComparados" >Compared Served</div
@%end-if:%@
@%if:AllowedPII;DevolucionesComparadas;%@
><div name="DevolucionesComparadas" >Compared Returns</div
@%end-if:%@
@%if:AllowedPII;BajasComparadas;%@
><div name="BajasComparadas" >Compared Stock Downs</div
@%end-if:%@
@%end-if:%@
@%if:AllowedPII;TopClientes;%@
><div name="TopClientes" >Top Clients</div
@%end-if:%@
@%if:AllowedPII;TopProveedores;%@
><div name="TopProveedores" >Top Suppliers</div
@%end-if:%@
@%if:AllowedPII;TopAgentes;%@
><div name="TopAgentes" 
@%if:equals;_krn_ss_name;dashboard_articulos_topventa;%@
class="activo"
@%end-if:%@
>Top Agents</div
@%end-if:%@
></div>

@%if:!equals;dsb_term;anyo;%@
<div class="PIIFicha" id="IndicadoresComparados" >
@%plt:IndicadoresComparados;%@
</div>
<div class="PIIFicha" id="PedidosComparados" >
@%plt:PedidosComparados;%@
</div>
<div class="PIIFicha" id="ServidoComparados" >
@%plt:ServidoComparados;%@
</div>
<div class="PIIFicha" id="DevolucionesComparadas" >
@%plt:DevolucionesComparadas;%@
</div>
<div class="PIIFicha" id="BajasComparadas" >
@%plt:BajasComparadas;%@
</div>
@%end-if:%@

<div class="PIIFicha" id="TopClientes" >
@%plt:TopClientes;%@
</div>
<div class="PIIFicha" id="TopProveedores" >
@%plt:TopProveedores;%@
</div>
<div class="PIIFicha" id="TopAgentes" >
@%plt:TopAgentes;%@
</div>

<div class="PIIContainer" id="FichaTab_DashboardArticulosExtern"
@%if:!equals;_krn_ss_name;dashboard_articulos_venta;%@
><div name="ArticulosPorVenta" ><a href="?seccion=dashboard_articulos_venta" class="cambio_ss" >Value in Sales</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_articulos_servidoventa;%@
><div name="ArticulosServidoVenta" ><a href="?seccion=dashboard_articulos_servidoventa" class="cambio_ss" >Served in Sales</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_articulos_topventa;%@
><div name="ArticulosTopVenta" ><a href="?seccion=dashboard_articulos_topventa" class="cambio_ss" >Top Sales</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_articulos_compra;%@
><div name="ArticulosPorCompra" ><a href="?seccion=dashboard_articulos_compra" class="cambio_ss" >Value in Purchases</a></div
@%end-if:%@
></div>

<script >
<!-- 
TabDashboardArticulos = new TabGroup(document.getElementById('FichaTab_DashboardArticulos'));
TabDashboardArticulosExtern = new TabGroup(document.getElementById('FichaTab_DashboardArticulosExtern'));
// -->
</script>

