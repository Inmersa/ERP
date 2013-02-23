@%where:nodb|class_dbItemMultiEntity_iface;nombre|CabeceraAlbaran;%@

<fieldset id="DatosAlbaran" class="fsficha">
<legend>Guia de Remessa (@%db:Origen.nombre;%@)</legend>
<table class="full">
<tr>
<td class="etiqueta" colspan="2">Referência:</td>
<td colspan="2">@%db:referencia%@</td>
<td class="etiqueta" colspan="2">Referência Externa:</td>
<td colspan="2"><input type="text" name="registro[referencia_externa]" value="@%db:referencia_externa;%@" /></td>
</tr>
<tr>
<td class="etiqueta" colspan="2">Ref. Encomenda:</td>
<td colspan="2">
@%if:!esta_vacio;Pedido.referencia;%@
@%if:esta_vacio;Destino.id_direccion;%@
	@%if:AllowedLink;bo_pedido_proveedor;%@
	<a href="?seccion=bo_pedido_proveedor&id_pedido=@%db:Pedido.id_pedido;%@">@%db:Pedido.referencia;%@</a>
	@%else:%@
	@%db:Pedido.referencia;%@
	@%end-if:%@
@%else:%@
	@%if:AllowedLink;bo_pedido_cliente;%@
	<a href="?seccion=bo_pedido_cliente&id_pedido=@%db:Pedido.id_pedido;%@">@%db:Pedido.referencia;%@</a>
	@%else:%@
	@%db:Pedido.referencia;%@
	@%end-if:%@
@%end-if:%@
@%end-if:%@
</td>
<td colspan="2" class="etiqueta" >Data de Saída</td>
<td>@%db:colocar_fecha{fecha_envio};%@</td>
</tr>
<tr><td class="etiqueta" colspan="2">Observações:</td>
<td colspan="10" colspan="2">
<textarea name="registro[observaciones]" rows="3" cols="50">@%db:observaciones;%@</textarea></td>
 </tr>
<tr><td class="etiqueta" colspan="2">Data:</td>
<td colspan="2" ><input type="text" name="registro[fecha]" class="fechahora" value="@%db:colocar_fecha{fecha};%@" /></td>
<td class="etiqueta" colspan="2">Transportador:</td>
<td colspan="2">
 <!-- @%set:_selected_value=id_transportista;%@ -->
<select name="registro[id_transportista]">
@%where:tabla|Transportistas;nolink|1;nombre|transporte;%@
 <option value="@%db:Transportistas.id_transportista;%@" 
 	@%db:selected_value{Transportistas.id_transportista};%@
	>@%db:Transportistas.nombre;%@</option>
@%end-where:%@

</select></td>
</tr>
</table>
<table class="full" >
<caption class="titulotb" >Estados </caption>
<tbody>
<tr>
<td class="etiqueta" >Embalagens:</td>
<td class="check" ><input type="text" name="registro[bultos]" value="@%db:bultos;%@" class="bultos" ></td>
<td class="etiqueta">P</td>
<td class="check"><input type="checkbox" name="registro[preparado]" value="1" @%db:check_flag{preparado}%@ /></td>
<td class="etiqueta">E</td>
<td class="check"><input type="checkbox" name="registro[enviado]" value="1" @%db:check_flag{enviado}%@ /></td>
<td class="etiqueta">C</td>
<td class="check"><input type="checkbox" name="registro[confirmacion]" value="1" @%db:check_flag{confirmacion}%@ /></td>
<td class="etiqueta">D</td>
<td class="check">@%db:si_no_flag{devolucion}%@</td>
</tr>
</tbody>
</table>
<div class="barraoscurai">Legenda: P- Preparada E- Emitida C- Confirmada D- Devolvida</div>
</fieldset>

