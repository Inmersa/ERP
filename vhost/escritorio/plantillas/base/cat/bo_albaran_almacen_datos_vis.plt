@%where:Albaranes;where|id_albaran = $id_albaran;%@
<!-- @%db:Albaranes.id_albaran;%@ @%db:Pedidos.id_direccion;%@ -->
<fieldset id="DatosAlbaran" class="fsficha">
<legend>Condicions de remesa</legend>
<table class="full">
<tr>
<td class="etiqueta" colspan="2">Referència:</td>
<td colspan="2">@%db:Albaranes.referencia;%@</td>
<td class="etiqueta" colspan="2">Magatzem:</td>
<td colspan="2">@%db:Almacenes.nombre;%@</td>
</tr>
<tr>
<td class="etiqueta" colspan="2">Ref. Comanda:</td>
<td colspan="2">
@%if:esta_vacio;Pedidos.id_direccion;%@
<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%else:%@
<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedidos.id_pedido;%@">@%db:Pedidos.referencia;%@</a>
@%end-if:%@
</td>
<td class="etiqueta" colspan="2">Paquets:</td>
<td  colspan="2">@%db:Albaranes.bultos;%@</td>
</tr>
<tr><td class="etiqueta" colspan="2">Observacions:</td>
<td colspan="6" >@%db:reemplazar_salto{Albaranes.observaciones};%@</td> 
</tr>
<tr><td class="etiqueta" colspan="2">Data:</td>
<td>@%db:colocar_fecha{Albaranes.fecha};%@</td>
<td class="etiqueta" colspan="2">Transportistes:</td>
<td colspan="3"><!-- @%db:Albaranes.id_transportista;%@ -->
@%where:tabla|Transportistas;nombre|transporte;%@
@%db:Transportistas.nombre;%@
@%end-where:%@

</td></tr>

<tr>
<td class="titulotb" colspan="8">Estats </td>
</tr>
<tr>
<td class="etiqueta">P</td>
<td class="check">@%db:si_no_flag{Albaranes.preparado}%@</td>
<td class="etiqueta">R</td>
<td class="check">@%db:si_no_flag{Albaranes.enviado}%@</td>
<td class="etiqueta">C</td>
<td class="check">@%db:si_no_flag{Albaranes.confirmacion}%@</td>
<td class="etiqueta">T</td>
<td class="check">@%db:si_no_flag{Albaranes.devolucion}%@</td>
</tr>
</table>
</fieldset>

