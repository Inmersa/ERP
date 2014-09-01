
<form name="pedido_reposicion" action="?seccion=hacer_pedido_compra&nuevo=1" method="post">
<input type="hidden" name="nuevo" value="1" />
<input type="hidden" name="pedido" value="1" />
<input type="hidden" name="id_proveedor" value="@%get:id_proveedor;%@" />

<fieldset class="fsficha">
<legend>Order Rerun</legend>

<div class="AccionesFicha"><ul>
<li><a href="#" onClick="return sendForm('pedido_reposicion');" class="enviar" ><img src="images/pixel.png" class="icono" /><span>Send</span></a></li>
</ul></div>

<table class="full">
<tr>
<td class="etiqueta" >Residual Orders</td>
<td class="check" ><input type="checkbox" name="repo[residuales]" value="1" /></td>
<td class="etiqueta" >To exclude Residual Orders</td>
<td class="check" ><input type="checkbox" name="repo[sin_residuales]" value="1" /></td></tr>

<tr><td class="etiqueta">Starting date:</td>
<td><input type="text" name="repo[fecha_inicio]" value="dd/mm/yyyy" size="12" /></td>
<td class="etiqueta">Last date:</td>
<td><input type="text" name="repo[fecha_fin]" value="dd/mm/yyyy" size="12" />
</td></tr>
</table>
</fieldset></form>

