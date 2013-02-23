
<form name="directo_codigobarras" method="post" action="?seccion=pkg_tpv_cbarras" id="frm_preparar" >
<input type="hidden" name="accion" value="New" />
<input type="hidden" name="tpvopt_return_section" value="pkg_inicio" />
<input type="hidden" name="tpvopt_addnew" value="1" />
<table class="full" style="border: 1px solid black;" id="directo_codigo" name="Lista" >
<thead><tr>
</tr></thead>
<tbody>

<tr ><td>
	<div id="DivLocation_CB" name="DetalleAlbaran" >
	<span>Direction à remise</span>
	<div name="CodigoBarras" class="nooculto" 
		><input type="text" id="barrasDirecto" name="id_direccion" value="" class="codigobarras" /></div>
	</div>
</td></tr>

</tbody></table>
</form>

<script type="text/javascript" >
$('barrasDirecto').focus();
</script>

