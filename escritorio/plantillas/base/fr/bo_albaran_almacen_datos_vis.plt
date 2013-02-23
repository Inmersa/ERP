@%where:Albaranes;where|id_albaran = $id_albaran;%@
<!-- @%db:Albaranes.id_albaran;%@ @%db:Pedidos.id_direccion;%@ -->
<fieldset id="DatosAlbaran" class="fsficha">
<legend>Conditions d'envoi</legend>
<table class="full">
<tr>
<td class="etiqueta" colspan="2">Référence:</td>
<td colspan="2">@%db:Albaranes.referencia;%@</td>
<td class="etiqueta" colspan="2">Magasin:</td>
<td colspan="2">@%db:Almacenes.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta" colspan="2">Ref. Commande:</td>
<td colspan="2">
@%if:esta_vacio;Pedidos.id_direccion;%@
<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%else:%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%end-if:%@
</td>
<td class="etiqueta" colspan="2">Bosses:</td>
<td  colspan="2">@%db:Albaranes.bultos;%@</td>
</tr>
<tr><td class="etiqueta" colspan="2">Observationes:</td>
<td colspan="6" >@%db:reemplazar_salto{Albaranes.observaciones};%@</td> 
</tr>
<tr><td class="etiqueta" colspan="2">Date:</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
<td class="etiqueta" colspan="2">Transporteurs:</td>
<td colspan="3"><!-- @%db:Albaranes.id_transportista;%@ -->
@%where:tabla|Transportistas;nombre|transporte;%@
@%db:Transportistas.nombre;%@
@%end-where:%@

</td></tr>

<tr>
<td class="titulotb" colspan="8">État </td>
</tr>
<tr>
<td class="etiqueta">P</td>
<td class="check">@%db:si_no_flag{Albaranes.preparado}%@</td>
<td class="etiqueta">E</td>
<td class="check">@%db:si_no_flag{Albaranes.enviado}%@</td>
<td class="etiqueta">C</td>
<td class="check">@%db:si_no_flag{Albaranes.confirmacion}%@</td>
<td class="etiqueta">R</td>
<td class="check">@%db:si_no_flag{Albaranes.devolucion}%@</td>
</tr>
</table>
</fieldset>

