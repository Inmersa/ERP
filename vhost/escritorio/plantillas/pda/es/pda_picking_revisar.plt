
<table class="full" id="Leyenda" name="Leyenda" >
<thead><tr>
</tr></thead>
<tbody>
<tr ><td>1</td><td>Revisar Excedentes</td></tr>
<tr ><td>3</td><td>Ir al Menu Principal</td></tr>
<tr ><td>5</td><td>Ir a Confirmar Albaran</td></tr>
<tr ><td>0</td><td>Enviar Modificaciones</td></tr>
</tbody></table>

<form name="albaranes_list" method="post" action="?seccion=pkg_revisar_venta" id="frm_revisar" >
<input type="hidden" name="__iface_followup" value="pkg_inicio" />
<input type="hidden" name="__iface_followup_setvar" value="accion" />
<input type="hidden" name="__iface_followup_setval" value="Confirmar" />

<input type="hidden" name="__iface_key_3" value="pkg_inicio" />
<input type="hidden" name="__iface_key_3_setvar" value="accion" />
<input type="hidden" name="__iface_key_3_setval" value="none" />
<input type="hidden" name="__iface_key_5" value="pkg_inicio" />
<input type="hidden" name="__iface_key_5_setvar" value="accion" />
<input type="hidden" name="__iface_key_5_setval" value="Confirmar" />

<input type="hidden" name="__iface_key_0" value="pkg_revisar_venta" />
<input type="hidden" name="__iface_key_0_setvar" value="accion" />
@%if:!esta_vacio;__pack_excedentes;%@
<input type="hidden" name="__iface_key_0_setval" value="ConfirmarExcedentes" />
	@%plt:Excedentes;%@
@%else:%@
<input type="hidden" name="__iface_key_0_setval" value="ConfirmarFaltas" />
	@%plt:Faltas;%@
@%end-if:%@
</form>

<script type="text/javascript" >
oM = new Menu($('frm_revisar'));
oT = new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':TBItem_Location});
oSW = new TableSwitcher($('Leyenda'));
oSW.add(oT,"NUM_1");
oSW.registerDefaultKeyHandler(oM.keyPress.bind(oM));
oSW.activate(0);
oKb = new KeyboardDriver(document);
oKb.register("all",oSW.keyPress.bind(oSW));
</script>

