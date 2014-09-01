
<table class="full" id="Leyenda" name="Leyenda" >
<thead><tr>
</tr></thead>
<tbody>
<tr ><td>1</td><td>Entrada de datos</td></tr>
<tr ><td>2</td><td>Informacion de la Referencia</td></tr>
<tr ><td>3</td><td>Informacion de Inventario</td></tr>
<tr ><td>4</td><td>Registro de Estados</td></tr>
<tr ><td>0</td><td>Enviar Baja</td></tr>
</tbody></table>

<div name="Contenedor" id="Contenido" >
	Informacion no disponible
</div>

<div name="Inventario" id="Inventario" ></div>
<div name="Log" id="Log" ><div class="req_log_line" /> -- Start Up -- </div></div>

<form name="directo_codigobarras" method="post" action="?seccion=ajax_alb_accion" id="frm_referencia" >
<input type="hidden" name="NO__iface_followup" value="pkg_bajas_cbarras" />
<input type="hidden" name="accion" value="Confirmar" />

<input type="hidden" name="__iface_key_0" value="pkg_bajas_cbarras" />

<div id="detalle" name="Lista">

	<div id="AjaxInfo" ></div>
	<span><input type="checkbox" name="none" value="1" id="checkit" />Códi de barres</span>
	<div name="CodigoBarras" class="nooculto" 
		><input type="text" id="barrasDirecto" tabindex="10" name="CodigoBarras" value="" class="codigobarras" /></div>

	<div name="Localizacion" >
	<div name="CBarras_localizacion" class="oculto" id="CodBarras_"
	><input type="text" name="comprobacionBarras[]" value="" class="codigobarras" /></div>
	<!-- @%set:_selected_value=Detalle.id_almacen_logico;value|var;%@ -->
	<select name="nloc[id_almacen_logico]" tabindex="20" class="zona" >
	@%where:table|Almacenes_logicos;nolink|1;%@
	<option value="@%db:Almacenes_logicos.id_almacen_logico;%@" 
		@%db:selected_value{Almacenes_logicos.id_almacen_logico};%@
		>@%db:Almacenes_logicos.nombre;%@</option>
	@%end-where:%@

	</select><br/>

	<input type="text" class="planta" name="nloc[planta]" value="" tabindex="21" />:
	<input type="text" class="pasillo" name="nloc[pasillo]" value="" tabindex="22" />:
	<input type="text" class="columna" name="nloc[columna]" value="" tabindex="23" />:
	<input type="text" class="fila" name="nloc[fila]" value="" tabindex="24" />
	</div>

	<div name="SKU" >
	<input tabindex="31" type="text" class="dia" name="nloc[fecha_caducidad][dia]" value="" /> /
	<input tabindex="32" type="text" class="mes" name="nloc[fecha_caducidad][mes]" value=""  /> /
	<input tabindex="33" type="text" class="anyo" name="nloc[fecha_caducidad][ano]" value=""  /> *
	<input tabindex="34" type="text" class="lote" name="nloc[lote]" value=""  />
	</div>

	<div name="Cantidad" id="DivLocation_cnt" 
		><input type="text" class="cantidad" name="nloc[cantidad]" value="" tabindex="40" /> 
	{{abr_cantidad_pendiente}}: NaN {{abr_cantidad_pedida}}: NaN</div>
</div>
El ReqAjax : @%get:_Ajax_request;%@
<script type="text/javascript" >
oKb = new KeyboardDriver(document);
oSW = new TableSwitcher($('Leyenda'));
oM = new Menu($('frm_referencia'));
oInfo = new ReferenceInfo($('Contenido'));
oStock = new ReferenceInfo($('Inventario'));
oLog = new ReferenceInfo($('Log'));
oRec = new DeliveryEntry($('detalle'));

oRec.setAjaxStatus($('AjaxInfo'));
oRec.setAjaxStock($('Inventario'));
oRec.setAjaxInfo($('Contenido'));
oRec.setAjaxLog($('Log'));

oRec.setParkingFocus($('checkit'),oKb);
oRec.setRecordForm($('frm_referencia'));
oSW.add(oRec,"NUM_1");
oSW.add(oInfo,"NUM_2");
oSW.add(oStock,"NUM_3");
oSW.add(oLog,"NUM_4");
oSW.registerDefaultKeyHandler(oM.keyPress.bind(oM));
oSW.deactivate(1);
oSW.deactivate(2);
oSW.deactivate(3);
oSW.activate(0);
oKb.register("all",oSW.keyPress.bind(oSW));
</script>

