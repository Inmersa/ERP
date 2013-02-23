
<div id="AccionesEncabezado"><ul>
@%if:AllowedLink;nuevo_rappel_cliente;%@
<li><a href="?seccion=nuevo_rappel_cliente" class="nuevo" ><img src="images/pixel.png" class="icono" /><span>Add rappel</span></a></li>
@%end-if:%@
<li><a href="#" onClick="return onHRefClick('rappel_cliente','accion_ejecutar','Borrar');" class="borrar" ><img src="images/pixel.png" class="icono" /><span>Delete selected</span></a></li>
</ul></div>

<form name="rappel_cliente" method="post" action="?seccion=@%get:_krn_ss_name;%@">
<input type="hidden" name="accion_ejecutar" value="0" />

<table class="full">
<thead>
<tr>
<td colspan="3">Finished 12 months</td>
<td class="caption">of</td>
</tr>
</thead>
<tbody>
@%where:tabla|Rappel;where|id_cliente = $id_cliente_promocion AND id_empresa = $id_empresa;%@
<tr>
<td class="check"><input type="checkbox" name="rappel_borrar[@%db:Rappel.id_rappel%@]" value="1" /></td>
<td class="etiqueta" > of <input type="text" name="rappel[@%db:Rappel.id_rappel%@][monto_inicial]" value="@%db:Rappel.monto_inicial;%@" size="11" maxlength="11" />
to <input type="text" name="rappel[@%db:Rappel.id_rappel%@][monto_final]" value="@%db:Rappel.monto_final;%@" size="11" maxlength="11" /></td>
<td >
<input type="text" name="rappel[@%db:Rappel.id_rappel%@][porcentaje]" value="@%db:Rappel.porcentaje;%@" size="5" maxlength="5" />%
</td>

<td align="center" >
<input type="text" name="rappel[@%db:Rappel.id_rappel%@][fecha_inicial]" value="@%db:colocar_fecha{Rappel.fecha_inicial};%@" size="12" class="insertextnumeros" maxlength="12" />
</td>
</tr>
@%end-where:%@

</tbody>
</table>
</form>

<div class="AccionesEnvio"><ul>
<li><a href="#" onClick="return onHRefClick('rappel_cliente','accion_ejecutar','Modificar');" class="guardar" 
	><img src="images/pixel.png" class="icono" /><span>Modify</span></a></li>
</ul></div>


