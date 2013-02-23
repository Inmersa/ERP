
<form name="directo_codigobarras" method="post" action="?seccion=pkg_inventario" id="frm_baja" >
<input type="hidden" name="accion" value="SeleccionarCBarras" />
<input type="hidden" name="invent_return_section" value="pkg_baja" />

<table class="full" style="border: 1px solid black;" id="directo_codigo" name="Lista" >
<thead><tr>
</tr></thead>
<tbody>

<tr ><td>
	<div id="DivLocation_CB" name="DetalleAlbaran" >
	<span>{{fld_codigobarras}}</span>
	<div name="CodigoBarras" class="nooculto" 
		><input type="text" id="barrasDirecto" name="CodigoBarras" value="" class="codigobarras" /></div>
	</div>
</td></tr>

</tbody></table>
</form>


<script type="text/javascript" >
$('barrasDirecto').focus();
</script>

