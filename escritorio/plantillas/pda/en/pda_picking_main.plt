
<table class="full" id="Leyenda" name="Leyenda" >
<thead><tr>
</tr></thead>
<tbody>
<tr ><td>1</td><td>Menu Principal</td></tr>
<tr ><td>2</td><td>Codigo de Albaran</td></tr>
</tbody></table>

<form name="albaranes_list" id="albaranes_list" method="post" action="?seccion=pkg_albaranes_venta" >
<input type="hidden" name="accion" value="Preparar" />

<table class="full" style="border: 1px solid blue;" id="listado" >
<thead><tr><td></td></tr></thead>
<tbody>

<tr >
<td class="check" ><input type="radio" name="target" value="pkg_albaranes_venta" /></td>
<td >Poner Albaran de Venta</td>
</tr>

<tr >
<td class="check" ><input type="radio" name="target" value="pkg_albaranes_compra" /></td>
<td >Poner Albaran de Compra</td>
</tr>

<tr >
<td class="check" ><input type="radio" name="target" value="pkg_moverstock" /></td>
<td >Mover stock de Localizacion</td>
</tr>

<tr >
<td class="check" ><input type="radio" name="target" value="pkg_bajas_cbarras" /></td>
<td >Dar de baja Stock</td>
</tr>

<tr >
<td class="check" ><input type="radio" name="target" value="pkg_tpv_direccion" /></td>
<td >Nuevo Albaran</td>
</tr>

</tbody></table>
</form>

<div id="CBarras">
<form method="post" action="?seccion=pkg_albaran_ajax" >
<input type="hidden" name="accion" value="Preparar" />
<input type="text" name="IDAlbaran" id="barrasDirecto" value="" />
</form>
</div>

<script type="text/javascript" >
oSW = new TableSwitcher($('Leyenda'));
oM = new Menu($('listado'));
oT = new TableBrowser($('listado'),null,oM.selectItem);
oT.registerDefaultKeyHandler(oM.keyPress.bind(oM));
oCBAlb = new ReferenceInfo($('CBarras'));
oCBAlb.cssContentVisible = "nooculto";
oCBAlb.focus = function () {
	this.getItem().className = this.cssContentVisible;
	$('barrasDirecto').focus();
}
oSW.add(oT,"NUM_1");
oSW.add(oCBAlb,"NUM_2");
oSW.deactivate(1);
oSW.activate(0);
oKb = new KeyboardDriver(document);
oKb.register("all",oSW.keyPress.bind(oSW));
</script>

