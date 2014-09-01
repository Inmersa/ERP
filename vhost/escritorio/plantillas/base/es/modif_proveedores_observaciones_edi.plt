@%where:tabla|Proveedores;where|Proveedores_empresas.id_proveedor = $id_proveedor_promocion AND Proveedores_empresas.id_empresa = $id_empresa;%@

<fieldset class="fsficha">
<legend>{{label_observaciones}}:</legend>
<table class="full">
<tr><td class="etiqueta">Fecha de alta:</td>
<td>@%db:colocar_fecha{Proveedores_empresas.fecha_alta};%@ <input type="hidden" name="registro2[fecha_alta]" value="@%db:Proveedores_empresas.fecha_alta;%@" /></td>
<td class="etiqueta">Activo:</td>
<td class="check"><!--@%db:Proveedores_empresas.activo;%@--> <input type="checkbox" name="registro2[activo]" value="1" @%func:obtener_activo%@ /></td>
</tr>
<tr><td class="etiqueta">Observaciones:</td><td colspan="3"><textarea name="registro2[observaciones]" class="desc" 
	>@%db:Proveedores_empresas.observaciones;%@</textarea></td></tr>
</table>
</fieldset>


