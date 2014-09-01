
<div class="tituloseccion" >
@%if:equals;_krn_ss_name;dashboard_almacenes;%@
Armazéns 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas;%@
Faltas em Venda 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
Faltas em Compra 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
Reembolsos em Venda 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
Reembolsos em Compra 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
Baixas em Armazéns 
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
Por Mês (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Por Mês</a>
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
Por Ano (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Por Ano</a>
@%end-if:%@
</div></div>


<div class="PIIFichaBase" id="Indicadores_Generales" >
@%plt:IndicadoresGenerales;%@
</div>

<div class="PIIContainer" id="FichaTab_DashboardAlmacenes" 
@%if:equals;_krn_ss_name;dashboard_almacenes;%@
@%if:AllowedPII;Stock;%@
><div name="Stock" class="activo" >Existências</div
@%end-if:%@
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_faltas;%@
><div name="TopMarcas" class="activo" >Faltas em Marca</div
><div name="TopClientes" >Faltas em Cliente</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="TopMarcas" class="activo" >Faltas em Marca</div
><div name="TopProveedores" >Faltas em Fornecedor</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="TopMarcas" class="activo" >Reembolsos por Marca</div
><div name="TopClientes" >Reembolsos por Cliente</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="TopMarcas" class="activo" >Reembolsos por Marca</div
><div name="TopProveedores" >Reembolsos por Fornecedor</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="TopArticulos" class="activo" >Baixas por Artigo</div
><div name="TopMarcas" >Baixas por Marca</div
><div name="TopClientes" >Baixas por Cliente</div
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
><div name="Stock" ><a href="?seccion=dashboard_almacenes" class="cambio_ss" >Existências</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_faltas;%@
><div name="FaltasVenta" ><a href="?seccion=dashboard_almacenes_faltas" class="cambio_ss" >Faltas em Vendas</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="FaltasCompra" ><a href="?seccion=dashboard_almacenes_faltas_compras" class="cambio_ss" >Faltas em Compras</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_venta" class="cambio_ss" >Reembolsos em Vendas</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_compra" class="cambio_ss" >Reembolsos em Compras</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="Bajas" ><a href="?seccion=dashboard_almacenes_bajas" class="cambio_ss" >Baixas</a></div
@%end-if:%@

></div>

<script >
<!-- 
TabDashboardAlmacenes = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenes'));
TabDashboardAlmacenesExtern = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenesExtern'));
// -->
</script>

