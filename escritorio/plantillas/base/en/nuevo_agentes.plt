
<div class="tituloseccion">&gt; New agent </div>

<form name="nuevo_agentes" action="?seccion=bo_agentes" method="post">
<fieldset id="Nuevo_Agentes" class="fsficha">
<legend>Contact</legend>
<table class="full">
<tr>
<td class="etiqueta">Name</td>
<td><input type="text" name="registro[nombre]" size="30" /></td>
<td class="etiqueta">Phone 1</td>
<td><input type="text" name="registro[telefono1]" size="12" /></td>
</tr>
<tr>
<td class="etiqueta">Last name
</td>
<td>
<input type="text" name="registro[apellidos]" size="30" />
</td>
<td class="etiqueta">Phone 2
</td>
<td>
<input type="text" name="registro[telefono2]" size="12" />
</td>
</tr>
<tr>
<td class="etiqueta">Address
</td>
<td>
<input type="text" name="registro[direccion]" size="30" />
</td>
<td class="etiqueta">City
</td>
<td>
<input type="text" name="registro[poblacion]" size="12" />
</td>
</tr>
<tr>
<td class="etiqueta">Area
</td>
<td>
<select name="registro[id_provincia]">
@%where:tabla|Provincias;order|nombre;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@">@%db:Provincias.nombre;%@</option>
@%end-where:%@

</select>
</td>
<td class="etiqueta">Postal Code
</td>
<td>
<input type="text" name="registro[cp]" size="6" />
</td>
</tr>
<tr>
<td class="etiqueta">User
</td>
<td>
<input type="text" name="registro[login]" size="16" />
</td>
<td class="etiqueta">Type of agent
</td>
<td>
<select name="registro[id_tipo_agente]">
@%where:tabla|Tipo_agente;order|nombre;nolink|1;%@
<option value="@%db:Tipo_agente.id_tipo_agente%@">@%db:Tipo_agente.nombre%@</option>
@%end-where:%@

</select>
</td>
</tr>
<tr>
<td class="etiqueta">Password</td>
<td><input type="password" name="registro[passwd]" size="14" /></td>
<td class="etiqueta">Confirmation</td>
<td><input type="password" name="registro[passwd2]" size="12" /></td>
</tr>

<tr>
<td class="etiqueta">Base Commission</td>
<td><input type="text" name="registro[comision_base]" size="6" /></td>
<td class="etiqueta">Shared Commission</td>
<td><input type="text" name="registro[comision_repartida]" size="6" /></td>
</tr>

</table>

 <table class="full">
 <tr>
   <td class="caption" colspan="6">IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Country / DC</td>
 <td><input type="text" name="registro[entidad]" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Branch</td>
 <td><input type="text" name="registro[oficina]" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta" >DC / Account Number</td>
 <td><input type="text" name="registro[dc_ccc]" size="2" maxlength="3" class="insertext">
 <input type="text" name="registro[cuenta_bancaria]" class="insertext" size="11" maxlength="10"></td>
</tr>
 <tr>
 <td class="etiqueta">Bank</td>
 <td><input type="text" name="registro[iban]" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Bank Identifier Code</td>
 <td><input type="text" name="registro[bic]" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">Bank Basic Account Number</td>
 <td><input type="text" name="registro[bban]" size="27" maxlength="26" class="insertext"></td>
 </tr>
</table>
</fieldset>
<input type="hidden" name="accion_ejecutar" value="Modificar" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="" onClick="return sendForm('nuevo_agentes');" class="guardar" ><img src="images/pixel.png" class="icono" /><span>New</span></a></li>
</ul></div>

