@%where:tabla|Agentes;where|id_agente = $id_agente_promocion;%@

<fieldset id="Modif_Agente_Datos" class="fsficha">
<legend>Dades generals</legend>

<table class="full">
<tr>
<td class="etiqueta">Tipus d´agent:</td>
<td><!-- @%db:Agentes.id_tipo_agente;%@ @%set:_selected_value=Agentes.id_tipo_agente;%@ -->
<select name="registro[id_tipo_agente]">
<option value="">Cap selecció</option>
@%where:tabla|Tipo_agente;order|Tipo_agente.nombre;nolink|1;%@
<option value="@%db:Tipo_agente.id_tipo_agente;%@" 
@%db:selected_value{Tipo_agente.id_tipo_agente}%@
>@%db:Tipo_agente.nombre;%@</option>
@%end-where:%@


</select></td>
</tr>
</table>

<table class="full">
<tr>
<td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" value="@%db:Agentes.nombre;%@" size="30" /></td>
<td class="etiqueta">Telèfon 1:</td>
<td><input type="text" name="registro[telefono1]" value="@%db:Agentes.telefono1;%@" size="12" /></td>
</tr>
<tr>
<td class="etiqueta">Cognoms:</td>
<td><input type="text" name="registro[apellidos]" value="@%db:Agentes.apellidos;%@" size="30" /></td>
<td class="etiqueta">Telèfon 2:</td>
<td><input type="text" name="registro[telefono2]" value="@%db:Agentes.telefono2;%@" size="12" /></td>
</tr>

<tr>
<td class="etiqueta">Adreça:</td>
<td><input type="text" name="registro[direccion]" value="@%db:Agentes.direccion;%@" size="30" /></td>
<td class="etiqueta">Població:</td>
<td><input type="text" name="registro[poblacion]" value="@%db:Agentes.poblacion;%@" size="12" /></td>
</tr>

<tr>
<td class="etiqueta">Província:</td>
<td><!-- @%db:Agentes.id_provincia;%@ @%set:_selected_value=Agentes.id_provincia;%@ -->
<select name="registro[id_provincia]">
 <option value="">Cap selecció</option>
 @%where:tabla|Provincias;order|Provincias.nombre;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@" 
@%db:selected_value{Provincias.id_provincia}%@ 
>@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select></td><td class="etiqueta">CP:</td>
<td><input type="text" name="registro[cp]" value="@%db:Agentes.cp;%@" size="6" /></td>
</tr>

<tr>
<td class="etiqueta">Comissió:</td>
<td>
<input type="text" name="registro[comision_base]" value="@%db:Agentes.comision_base;%@" size="6" /></td>
<td class="etiqueta">Comissió compartida:</td>
<td>
<input type="text" name="registro[comision_repartida]" value="@%db:Agentes.comision_repartida;%@" size="6" /></td>
</tr>

</table>

 <table class="full">
 <tr>
   <td class="caption" colspan="6">Compte bancari IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">País / DC</td>
 <td><input type="text" name="registro[entidad]" value="@%db:Agentes.entidad;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="registro[oficina]" value="@%db:Agentes.oficina;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta" >DC/ Nº Compte</td>
 <td><input type="text" name="registro[dc_ccc]" value="@%db:Agentes.dc_ccc;%@" size="2" maxlength="3" class="insertext">
 <input type="text" name="registro[cuenta_bancaria]" value="@%db:Agentes.cuenta_bancaria;%@" class="insertext" size="11" maxlength="10"></td>
</tr>
 <tr>
 <td class="etiqueta">Entitat</td>
 <td><input type="text" name="registro[iban]" value="@%db:Agentes.iban;%@" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Códi de Banc</td>
 <td><input type="text" name="registro[bic]" value="@%db:Agentes.bic;%@" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Compte Bancari Base</td>
 <td><input type="text" name="registro[bban]" value="@%db:Agentes.bban;%@" size="27" maxlength="26" class="insertext"></td>
 </tr>
</table>

</fieldset>

