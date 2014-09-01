
<form name="albaranes_list" method="post" action="?seccion=@%get:__tpv_sendto;%@" id="frm_preparar" >
<!-- form name="albaranes_list" method="post" action="?seccion=pkg_tpv" id="frm_preparar" >
<input type="hidden" name="__iface_followup" value="pkg_inicio" />
<input type="hidden" name="__iface_followup_setvar" value="accion" />
<input type="hidden" name="__iface_followup_setval" value="Confirmar" / -->

@%if:!esta_vacio;__tpv_resultados;%@
	@%plt:Resultado;%@
@%else:%@
	@%plt:Seleccionar;%@
@%end-if:%@
</form>

@%if:esta_vacio;__tpv_soloinfo;%@
<script type="text/javascript" >
// new TableBrowser(document.getElementById('listado'));
TableBrowser.prototype.form_id = "frm_preparar";
oTable1 = new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':SKU_Selection});
oKb = new KeyboardDriver(document);
oKb.register("all",oTable1.keyPress.bind(oTable1));
//oTable1.getRow(oTable1.firstIdx()).activate();
//oTable1.focus();
</script>
@%end-if:%@

