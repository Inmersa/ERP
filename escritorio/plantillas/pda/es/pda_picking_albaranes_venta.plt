
<form name="albaranes_list" id="albaranes_list" method="post" action="?seccion=pkg_preparar" >
<input type="hidden" name="accion" value="Preparar" />
<table class="full" style="border: 1px solid blue;" id="listado" >
<thead><tr>
</tr></thead>
<tbody>
@%where:Albaranes;where|preparado = 0 and (id_proveedor = 0 or id_proveedor IS NULL);order|fecha desc;contador|i;%@
<tr >
<td class="check" ><input type="radio" name="albaranes[@%db:i;%@]" value="@%db:Albaranes.id_albaran;%@" /></td>
<td >@%db:Albaranes.referencia;%@</td>
<td >@%db:Transportistas.nombre;%@</td>
<td >@%db:Direcciones_entrega.nombre;%@</td>
</tr>
@%end-where:%@

</tbody></table>
</form>

<script type="text/javascript" >
oM = new Menu();
TableBrowser.prototype.form_id = "albaranes_list";
oT = new TableBrowser(document.getElementById('listado'),null,oM.selectItem);
oKb = new KeyboardDriver(document);
oKb.register("all",oT.keyPress.bind(oT));
</script>

