
<form name="directo_codigobarras" method="post" action="?seccion=pkg_tpv" id="frm_preparar" >
<input type="hidden" name="accion" value="SeleccionarCBarras" />
<input type="hidden" name="tpvopt_return_section" value="pkg_tpv_cbarras" />
<input type="hidden" name="tpvopt_addnew" value="@%get:__tpv_addnew;%@" />

<table class="full" style="border: 1px solid black;" id="directo_codigo" name="Lista" >
<thead><tr>
</tr></thead>
<tbody>

<tr ><td>
	<div id="DivLocation_CB" name="DetalleAlbaran" >
	<span>Code-barres</span>
	<div name="CodigoBarras" class="nooculto" 
		><input type="text" id="barrasDirecto" name="CodigoBarras" value="" class="codigobarras" /></div>
	</div>
</td></tr>

</tbody></table>
</form>

<form action="#" method="post" id="frm_info" >
<table class="full" style="border: 1px solid black;" id="info_codigo" name="Lista" >
<thead><tr>
</tr></thead>
<tbody>

<tr ><td>
	<div id="DivLocation_CB" name="DetalleAlbaran" >
	<span>Code-barres - Info</span>
	<div name="CodigoBarras" class="nooculto" 
		><input type="text" id="barrasInfo" name="CodigoBarras" value="" class="codigobarras" /></div>
	</div>
</td></tr>

</tbody></table>
</form>

<div name="Contenedor" id="Contenido" >
	No hay referencia y tal
</div>

<script type="text/javascript" >
$('barrasDirecto').focus();
$('frm_info').onsubmit = function() {
	//var url = 'http://iface-gestion.proyectos.wol/~tite/iempresa/2_5/prueba.html';
	var url = 'http://iface-gestion.proyectos.wol/~tite/iempresa/2_5/escritorio/index.php?seccion=pkg_tpv';
	var pars = 'accion=Info&_Ajax_request=1&CodigoBarras='+inmForm.Element.getValue($('barrasInfo'));
	var myAjax = new Ajax.Updater(
		'Contenido',
		url,
		{
			method: 'post',
			parameters: pars
		});
	return false;
};
</script>

