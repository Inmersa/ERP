
<div class="tituloseccion" >
@%if:equals;_krn_ss_name;dashboard_almacenes;%@
Magasins 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas;%@
Manques en Vente 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
Manques en Achat 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
Remboursements en Vente 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
Remboursements en Achat 
@%end-if:%@
@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
Baisses dans des Magasins 
@%end-if:%@
[@%func:colocar_fecha;_dsb_fecha;%@]
</div>

<div id="DSBPeriodos" >
<div class="item" >
@%if:equals;dsb_term;semana;%@
Par Semaine (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=semana" >Par Semaine</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;mes;%@
Par Mois (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=mes" >Par Mois</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;trimestre;%@
Par Trimestriel (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=trimestre" >Par Trimestriel</a>
@%end-if:%@
</div>

<div class="item" >
@%if:equals;dsb_term;anyo;%@
Par Année (@%get:nombre_periodo_actual;%@)
@%else:%@
<a href="?seccion=@%get:_krn_ss_name;%@&periodo=anyo" >Par Année</a>
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
><div name="TopMarcas" class="activo" >Manques en Marque</div
><div name="TopClientes" >Manques en Client</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="TopMarcas" class="activo" >Manques en Marque</div
><div name="TopProveedores" >Manques en Fournisseur</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="TopMarcas" class="activo" >Remboursements par Marque</div
><div name="TopClientes" >Remboursements par Client</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="TopMarcas" class="activo" >Remboursements par Marque</div
><div name="TopProveedores" >Remboursements par Fournisseur</div
@%end-if:%@

@%if:equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="TopArticulos" class="activo" >Baisses par Article</div
><div name="TopMarcas" >Baisses par Marque</div
><div name="TopClientes" >Baisses par Client</div
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
><div name="FaltasVenta" ><a href="?seccion=dashboard_almacenes_faltas" class="cambio_ss" >Manques dans des Ventes</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_faltas_compras;%@
><div name="FaltasCompra" ><a href="?seccion=dashboard_almacenes_faltas_compras" class="cambio_ss" >Manques dans des Achats</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_venta;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_venta" class="cambio_ss" >Remboursements dans des Ventes</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_devoluciones_compra;%@
><div name="Devoluciones" ><a href="?seccion=dashboard_almacenes_devoluciones_compra" class="cambio_ss" >Remboursements dans des Achats</a></div
@%end-if:%@

@%if:!equals;_krn_ss_name;dashboard_almacenes_bajas;%@
><div name="Bajas" ><a href="?seccion=dashboard_almacenes_bajas" class="cambio_ss" >Baisses</a></div
@%end-if:%@

></div>

<script >
<!-- 
TabDashboardAlmacenes = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenes'));
TabDashboardAlmacenesExtern = new TabGroup(document.getElementById('FichaTab_DashboardAlmacenesExtern'));
// -->
</script>

