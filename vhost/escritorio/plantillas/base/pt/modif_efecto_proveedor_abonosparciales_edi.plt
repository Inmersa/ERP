@%where:tabla|Efectos;where|Efectos.id_efecto = $id_efecto;%@
<!-- @%db:Efectos.id_efecto%@ -->
<fieldset class="fsficha">
<legend>Liquidações Parciais</legend>

<div class="AccionesFicha"><ul>
<li><a href="#" onClick="return onHRefClick('efecto','accion_ejecutar','Borrar_parciales');"  class="borrar" 
	><img src="imag/pixel.png" class="icono" /><span>Eliminar Itens Seleccionados</span></a></li>
</ul></div>

<table class="full"><thead><tr> 
 <td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('borrar_parciales');"  /></td>
 <td >Data de Liquidação</td>
 <td >Meio de Pagamento</td>
 <td >Total</td> 
 <td >Banco</td> 
 <td >Nota de Crédito</td>
</tr></thead>
<tbody>
@%where:tabla|Efectos_parciales;%@ 
 <tr >
 <td class="check" ><input type="checkbox" name="borrar_parciales[]" value="@%db:Efectos_parciales.id_efecto_parcial%@" /></td>
 <td class="etiqueta" > @%db:colocar_fecha{Efectos_parciales.fecha}%@</td>
 <td >@%db:Efectos_parciales.medio_pago%@</td>
 <td >@%db:Efectos_parciales.monto_satisfecho%@</td>
 <td >
 @%where:tabla|Bancos;%@ 
 @%db:Bancos.nombre%@ 
 @%end-where:%@ 

 </td>
<td>
<!-- @%db:Efectos_parciales.id_factura_abono;%@ @%set:idfra_abono = Efectos_parciales.id_factura_abono;value|var;%@ -->
@%if:!esta_vacio;idfra_abono;%@
@%where:tabla|Facturas;where|Facturas.id_factura = $idfra_abono;%@
<!-- @%db:Facturas.id_cliente;%@ @%db:Facturas.id_proveedor;%@ -->
@%if:esta_vacio;Facturas.id_cliente;%@
	@%if:AllowedLink;bo_factura_proveedor;%@
	<a href="?seccion=bo_factura_proveedor&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a> (@%db:colocar_fecha{Facturas.fecha};%@)
	@%else:%@
	@%db:Facturas.referencia;%@ (@%db:colocar_fecha{Facturas.fecha};%@)
	@%end-if:%@
@%else:%@
	@%if:AllowedLink;bo_factura_cliente;%@
	 <a href="?seccion=bo_factura_cliente&id_factura=@%db:Facturas.id_factura;%@" >@%db:Facturas.referencia;%@</a> (@%db:colocar_fecha{Facturas.fecha};%@)
	@%else:%@
	@%db:Facturas.referencia;%@ (@%db:colocar_fecha{Facturas.fecha};%@)
	@%end-if:%@
@%end-if:%@
@%end-where:%@

@%end-if:%@
</td></tr>
 @%if:esta_vacio;Efectos_parciales.notas;%@
 @%else:%@
 <tr><td colspan="6">@%db:Efectos_parciales.notas%@</td></tr>
 @%end-if:%@

 @%end-where:%@ 
 
</tbody></table>
</fieldset>

