
<form name="albaranes_list" method="post" action="?seccion=pkg_albaranes_venta" >
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
<td class="check" ><input type="radio" name="target" value="pkg_bajas" /></td>
<td >Dar de baja Stock</td>
</tr>

</tbody></table>
</form>

<script type="text/javascript" >
oM = new Menu();
new TableBrowser(document.getElementById('listado'),null,oM.selectItem);
</script>

