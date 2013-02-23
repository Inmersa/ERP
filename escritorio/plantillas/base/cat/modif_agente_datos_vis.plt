@%where:tabla|Agentes;where|id_agente = $id_agente_promocion;%@
<!-- @%db:Agentes.id_agente;%@ -->

<fieldset id="Modif_Agente_Datos" class="fsficha">
<legend>Dades generals</legend>
<table class="full">
<tr>
<td class="etiqueta">Tipus d�agent:</td>
<td>
@%where:tabla|Tipo_agente;%@
@%db:Tipo_agente.nombre;%@
@%end-where:%@

</td>
</tr>
</table>

<table class="full">
<tr>
<td class="etiqueta">Nom:</td>
<td>@%db:Agentes.nombre;%@</td>
<td class="etiqueta">Tel�fon 1:</td>
<td>@%db:Agentes.telefono1;%@</td>
</tr>
<tr>
<td class="etiqueta">Cognoms:</td>
<td>@%db:Agentes.apellidos;%@</td>
<td class="etiqueta">Tel�fon 2:</td>
<td>@%db:Agentes.telefono2;%@</td>
</tr>

<tr>
<td class="etiqueta">Adre�a:</td>
<td>@%db:Agentes.direccion;%@</td>
<td class="etiqueta">Poblaci�:</td>
<td>@%db:Agentes.poblacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Prov�ncia:</td>
<td>
 @%where:tabla|Provincias;order|Provincias.nombre;%@
@%db:Provincias.nombre;%@
 @%end-where:%@

</td><td class="etiqueta">CP:</td>
<td>@%db:Agentes.cp;%@</td>
</tr>

<tr>
<td class="etiqueta">Comissi�:</td>
<td>@%db:Agentes.comision_base;%@</td>
<td class="etiqueta">Comissi� compartida:</td>
<td>@%db:Agentes.comision_repartida;%@</td>
</tr>

<tr>
<td class="etiqueta">Compte bancari IBAN:</td>
<td colspan="3">@%db:Agentes.cuenta_bancaria;%@</td>
</tr>
</table>

</fieldset>

