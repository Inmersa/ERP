
<fieldset id="DatosEfecto" class="fsficha">
<legend>Abonnaments partials</legend>

<div class="AccionesFicha"><ul>
<li><a href="#" onClick="return onHRefClick('efecto','accion_ejecutar','Borrar_parciales');"  class="borrar" ><img src="imag/pixel.png" class="icono" /><span>Elimier</span></a></li>
<li><a href="#" onClick="return SendFormToWindow('efecto','@%get:_krn_ss_name;%@&id=@%get:id_efecto;%@&imprimir=1','imprimir');" class="imprimir" 
	><img src="imag/pixel.png" class="icono" /><span>Imprimer</span></a></li>
</ul></div>

<table class="full">
<thead>
<tr>
<td class="estado" ><img src="imag/pixel.png" class="marcartodos" onclick="return formCheckAll('borrar_parciales');"  /></td>
<td >Date de d´abonnement</td>
<td >Moyen de payant</td>
<td >Montant</td>
<td >Banqe</td>
<td >Citation</td>
<td >Facture d'Engrais</td>
</tr>
</thead>
<tbody>
@%where:tabla|Efectos_parciales;where|Efectos_parciales.id_efecto = $id_efecto;%@
<tr>
<td class="check"><input type="checkbox" name="borrar_parciales[]" value="@%db:Efectos_parciales.id_efecto_parcial%@" /></td>
<td class="rail">@%db:colocar_fecha{Efectos_parciales.fecha}%@</td>
<td>@%db:Efectos_parciales.medio_pago%@</td>
<td>@%db:Efectos_parciales.monto_satisfecho%@</td>
<td>
@%where:tabla|Bancos;%@
@%db:Bancos.nombre%@
@%end-where:%@

</td><td>
@%where:tabla|Citas;%@
<!-- @%db:Citas.id_cita;%@ -->

@%if:AllowedLink;modif_cita;%@
<a href="?seccion=modif_cita&id_cita=@%db:Citas.id_cita;%@" >@%db:Rutas.nombre;%@ @%db:Recorridos.fecha;%@</a>
@%else:%@
@%db:Rutas.nombre;%@ @%db:Recorridos.fecha;%@
@%end-if:%@

(
@%if:AllowedLink;modif_cita;%@
<a href="?seccion=modif_agente&id_agente=@%db:Agentes.id_agente;%@" >@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@</a>
@%else:%@
@%db:Agentes.nombre;%@ @%db:Agentes.apellidos;%@ -<a href="mailto:@%db:Agentes.email;%@" >@%db:Agentes.email;%@</a>-
@%end-if:%@
)

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
@%if:!esta_vacio;Efectos_parciales.notas;%@
<tr><td colspan="6">@%db:Efectos_parciales.notas%@</td></tr>
@%end-if:%@
@%end-where:%@

</tbody></table>
</fieldset>

