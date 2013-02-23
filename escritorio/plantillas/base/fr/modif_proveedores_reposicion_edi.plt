
<form name="pedido_reposicion" action="?seccion=hacer_pedido_compra&nuevo=1" method="post">
<input type="hidden" name="nuevo" value="1" />
<input type="hidden" name="pedido" value="1" />
<input type="hidden" name="id_proveedor" value="@%get:id_proveedor;%@" />

<fieldset class="fsficha">
<legend>Commande Repeat</legend>

<div class="AccionesFicha"><ul>
<li><a href="#" onClick="return sendForm('pedido_reposicion');" class="enviar" ><img src="imag/pixel.png" class="icono" /><span>Accepter</span></a></li>
</ul></div>

<table class="full">
<tr>
<td class="etiqueta" >Commandes Résiduelles</td>
<td class="check" ><input type="checkbox" name="repo[residuales]" value="1" /></td>
<td class="etiqueta" >Exclure des Commandes Résiduelles</td>
<td class="check" ><input type="checkbox" name="repo[sin_residuales]" value="1" /></td></tr>

<tr><td class="etiqueta">Debut de periode:</td>
<td><input type="text" name="repo[fecha_inicio]" value="jj/mm/aaaa" size="12" /></td>
<td class="etiqueta">Derniére date:</td>
<td><input type="text" name="repo[fecha_fin]" value="jj/mm/aaaa" size="12" />
</td></tr>
</table>
</fieldset></form>

