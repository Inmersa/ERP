

<form name="albaranes_list" method="post" action="?seccion=pkg_revisar_venta" id="frm_preparar" >
<input type="hidden" name="__iface_followup" value="pkg_inicio" />
<input type="hidden" name="__iface_followup_setvar" value="accion" />
<input type="hidden" name="__iface_followup_setval" value="Confirmar" />

@%if:!esta_vacio;__pack_excedentes;%@
	@%plt:Excedentes;%@
@%else:%@
	@%plt:Faltas;%@
@%end-if:%@
</form>

<script type="text/javascript" >
// new TableBrowser(document.getElementById('listado'));
new TableBrowser($('listado'),{tagname:'DIV', name:'DetalleAlbaran', 'class':TBItem_Location});
</script>

