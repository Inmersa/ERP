
<div class="tituloseccion" >
@%if:equals_any;_krn_ss_name;dashboard_marcas_compra;dashboard_marcas_pedidocompra;dashboard_marcas_devolucioncompra;%@
Compra per Marques 
@%else:%@
Venda per Marques 
@%end-if:%@
[@%func:colocar_fecha;_dsb_fecha;%@]
@%if:!esta_vacio;id_marca;%@
@%where:tabla|Marcas;where|Marcas.id_marca = $id_marca;nolink|1;%@
@%db:Marcas.nombre;%@
@%end-where:%@

@%end-if:%@
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

<div class="PIIContainer" id="FichaTab_DashboardMarcas" 
@%if:!equals;dsb_term;anyo;%@
@%if:AllowedPII;IndicadoresComparados;%@
><div name="IndicadoresComparados" class="activo" >Valors Comparats</div
@%end-if:%@
@%if:AllowedPII;PedidosComparados;%@
><div name="PedidosComparados" 
@%if:equals_any;_krn_ss_name;dashboard_marcas_pedidoventa;dashboard_marcas_pedidocompra;%@
class="activo"
@%end-if:%@
>Comandes Comparades</div
@%end-if:%@
@%if:AllowedPII;ServidoComparados;%@
><div name="ServidoComparados" 
@%if:equals_any;_krn_ss_name;dashboard_marcas_devolucionventa;dashboard_marcas_devolucioncompra;%@
class="activo"
@%end-if:%@
>Servit Comparat</div
@%end-if:%@
@%if:AllowedPII;DevolucionesComparadas;%@
><div name="DevolucionesComparadas" >Devolucions Comparades</div
@%end-if:%@
@%if:AllowedPII;BajasComparadas;%@
><div name="BajasComparadas" >Baixes Comparades</div
@%end-if:%@
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

<div class="PIIContainer" id="FichaTab_DashboardMarcasExternVenta" 

@%if:!equals;_krn_ss_name;dashboard_marcas;%@
><div name="MarcasVenta" ><a href="?seccion=dashboard_marcas" class="cambio_ss" >Valors per Venda</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_marcas_pedidoventa;%@
><div name="MarcasPedidosVenta" ><a href="?seccion=dashboard_marcas_pedidoventa" class="cambio_ss" >Comandes en Venda</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_marcas_devolucionventa;%@
><div name="MarcasDevolucionesVenta" ><a href="?seccion=dashboard_marcas_devolucionventa" class="cambio_ss" >Devolucions en Venda</a></div
@%end-if:%@

></div>
<br/>
<div class="PIIContainer" id="FichaTab_DashboardMarcasExternCompra" 

@%if:!equals;_krn_ss_name;dashboard_marcas_compra;%@
><div name="MarcasCompra" ><a href="?seccion=dashboard_marcas_compra" class="cambio_ss" >Valors per Compra</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_marcas_pedidocompra;%@
><div name="MarcasPedidosCompra" ><a href="?seccion=dashboard_marcas_pedidocompra" class="cambio_ss" >Comandes en Compra</a></div
@%end-if:%@
@%if:!equals;_krn_ss_name;dashboard_marcas_devolucioncompra;%@
><div name="MarcasDevolucionesCompra" ><a href="?seccion=dashboard_marcas_devolucioncompra" class="cambio_ss" >Devolucions en Compra</a></div
@%end-if:%@

></div>

<script >
<!-- 
TabDashboardMarcas = new TabGroup(document.getElementById('FichaTab_DashboardMarcas'));
TabDashboardMarcasExternVenta = new TabGroup(document.getElementById('FichaTab_DashboardMarcasExternVenta'));
TabDashboardMarcasExternCompra = new TabGroup(document.getElementById('FichaTab_DashboardMarcasExternCompra'));
// -->
</script>

