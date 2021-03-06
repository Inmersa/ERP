
<fieldset id="DatosEfecto" class="fsficha">
<legend>Abonnaments partials</legend>

<table class="full">
<thead>
<tr>
<td >Date de dŽabonnement</td>
<td >Moyen de payant</td>
<td >Montant</td>
<td >Banqe</td>
<td >Citation</td>
</tr>
</thead>
<tbody>
@%where:tabla|Efectos_parciales;where|Efectos_parciales.id_efecto = $id_efecto;%@
<!-- @%db:Efectos_parciales.id_efecto_parcial;%@ @%db:Efectos_parciales.id_cita;%@ -->
<tr>
<td class="rail">@%db:colocar_fecha{Efectos_parciales.fecha}%@</td>
<td>@%db:Efectos_parciales.medio_pago%@</td>
<td>@%db:Efectos_parciales.monto_satisfecho%@</td>
<td>
@%where:tabla|Bancos;nolink|0;%@
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

</td></tr>
@%if:!esta_vacio;Efectos_parciales.notas;%@
<tr><td colspan="6">@%db:Efectos_parciales.notas%@</td></tr>
@%end-if:%@
@%end-where:%@

</tbody>
</table>
</fieldset>

