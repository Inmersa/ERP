
<div class="tituloseccion" >
@%if:!equals;_krn_ss_name;dashboard_articulos_compra;%@
Ventas por Artículo 
@%else:%@
Compras por Artículo 
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

<div class="PIIContainer" id="FichaTab_DashboardArticulos" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;IndicadoresComparados;%@
><div name="IndicadoresComparados" class="activo" >Valores Comparados</div
@%end-if:%@
@%if:AllowedPII;PedidosComparados;%@
><div name="PedidosComparados" 
@%if:equals;_krn_ss_name;dashboard_articulos_servidoventa;%@
class="activo"
@%end-if:%@
>Pedidos Comparados</div
@%end-if:%@
@%if:AllowedPII;ServidoComparados;%@
><div name="ServidoComparados" >Servido Comparado</div
@%end-if:%@
@%if:AllowedPII;DevolucionesComparadas;%@
><div name="DevolucionesComparadas" >Devoluciones Comparadas</div
@%end-if:%@
@%if:AllowedPII;BajasComparadas;%@
><div name="BajasComparadas" >Bajas Comparadas</div
@%end-if:%@
@%end-if:%@
@%if:AllowedPII;TopClientes;%@
><div name="TopClientes" >Top Cliente</div
@%end-if:%@
@%if:AllowedPII;TopProveedores;%@
><div name="TopProveedores" >Top Proveedores</div
@%end-if:%@
@%if:AllowedPII;TopAgentes;%@
><div name="TopAgentes" 
@%if:equals;_krn_ss_name;dashboard_articulos_topventa;%@
class="activo"
@%end-if:%@
>Top Agentes</div
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
><div name="ArticulosPorVenta" ><a href="?seccion=dashboard_articulos_venta" class="cambio_ss" >Valores en Venta</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_articulos_servidoventa;%@
><div name="ArticulosServidoVenta" ><a href="?seccion=dashboard_articulos_servidoventa" class="cambio_ss" >Servido en Ventas</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_articulos_topventa;%@
><div name="ArticulosTopVenta" ><a href="?seccion=dashboard_articulos_topventa" class="cambio_ss" >Top Venta</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_articulos_compra;%@
><div name="ArticulosPorCompra" ><a href="?seccion=dashboard_articulos_compra" class="cambio_ss" >Valores en Compra</a></div
@%end-if:%@
></div>

<script >
<!-- 
TabDashboardArticulos = new TabGroup(document.getElementById('FichaTab_DashboardArticulos'));
TabDashboardArticulosExtern = new TabGroup(document.getElementById('FichaTab_DashboardArticulosExtern'));
// -->
</script>

