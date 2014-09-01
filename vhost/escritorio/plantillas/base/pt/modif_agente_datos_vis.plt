@%where:tabla|Agentes;where|id_agente = $id_agente_promocion;%@
<!-- @%db:Agentes.id_agente;%@ -->

<fieldset id="Modif_Agente_Datos" class="fsficha">
<legend>Informações Gerais</legend>
<table class="full">
<tr>
<td class="etiqueta">Tipo de Agente:</td>
<td>
@%where:tabla|Tipo_agente;%@
@%db:Tipo_agente.nombre;%@
@%end-where:%@

</td>
</tr>
</table>

<table class="full">
<tr>
<td class="etiqueta">Nome:</td>
<td>@%db:Agentes.nombre;%@</td>
<td class="etiqueta">Telefone 1:</td>
<td>@%db:Agentes.telefono1;%@</td>
</tr>
<tr>
<td class="etiqueta">Apelidos:</td>
<td>@%db:Agentes.apellidos;%@</td>
<td class="etiqueta">Telefone 2:</td>
<td>@%db:Agentes.telefono2;%@</td>
</tr>

<tr>
<td class="etiqueta">Endereço:</td>
<td>@%db:Agentes.direccion;%@</td>
<td class="etiqueta">Localidade:</td>
<td>@%db:Agentes.poblacion;%@</td>
</tr>

<tr>
<td class="etiqueta">Distrito:</td>
<td>
 @%where:tabla|Provincias;order|Provincias.nombre;%@
@%db:Provincias.nombre;%@
 @%end-where:%@

</td><td class="etiqueta">CP:</td>
<td>@%db:Agentes.cp;%@</td>
</tr>

<tr>
<td class="etiqueta">Comissão Base:</td>
<td>@%db:Agentes.comision_base;%@</td>
<td class="etiqueta">Comissão Partilhada:</td>
<td>@%db:Agentes.comision_repartida;%@</td>
</tr>

<tr>
<td class="etiqueta">IBAN:</td>
<td colspan="3">@%db:Agentes.cuenta_bancaria;%@</td>
</tr>
</table>

</fieldset>

