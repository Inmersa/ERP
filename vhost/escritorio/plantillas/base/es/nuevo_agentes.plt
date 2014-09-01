
<div class="tituloseccion">&gt; Nuevo Agente </div>

<form name="nuevo_agentes" action="?seccion=bo_agentes" method="post">
<fieldset id="Nuevo_Agentes" class="fsficha">
<legend>Datos de Contacto</legend>
<table class="full">
<tr>
<td class="etiqueta">Nombre</td>
<td><input type="text" name="registro[nombre]" size="30" /></td>
<td class="etiqueta">Tel�fono 1</td>
<td><input type="text" name="registro[telefono1]" size="12" /></td>
</tr>
<tr>
<td class="etiqueta">Apellidos
</td>
<td>
<input type="text" name="registro[apellidos]" size="30" />
</td>
<td class="etiqueta">Tel�fono 2
</td>
<td>
<input type="text" name="registro[telefono2]" size="12" />
</td>
</tr>
<tr>
<td class="etiqueta">Direcci�n
</td>
<td>
<input type="text" name="registro[direccion]" size="30" />
</td>
<td class="etiqueta">Poblaci�n
</td>
<td>
<input type="text" name="registro[poblacion]" size="12" />
</td>
</tr>
<tr>
<td class="etiqueta">Provincia
</td>
<td>
<select name="registro[id_provincia]">
@%where:tabla|Provincias;order|nombre;nolink|1;%@
<option value="@%db:Provincias.id_provincia;%@">@%db:Provincias.nombre;%@</option>
@%end-where:%@

</select>
</td>
<td class="etiqueta">CP
</td>
<td>
<input type="text" name="registro[cp]" size="6" />
</td>
</tr>
<tr>
<td class="etiqueta">Usuario
</td>
<td>
<input type="text" name="registro[login]" size="16" />
</td>
<td class="etiqueta">Tipo de agente
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
<td class="etiqueta">Contrase�a</td>
<td><input type="password" name="registro[passwd]" size="14" /></td>
<td class="etiqueta">Confirmaci�n</td>
<td><input type="password" name="registro[passwd2]" size="12" /></td>
</tr>

<tr>
<td class="etiqueta">Comisi�n base</td>
<td><input type="text" name="registro[comision_base]" size="6" /></td>
<td class="etiqueta">Comisi�n de Reparto</td>
<td><input type="text" name="registro[comision_repartida]" size="6" /></td>
</tr>

</table>

 <table class="full">
 <tr>
   <td class="caption" colspan="6">Cuenta Bancaria IBAN</td>
 </tr>
<tr>
 <td class="etiqueta">Pa�s/DC</td>
 <td><input type="text" name="registro[entidad]" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">Oficina</td>
 <td><input type="text" name="registro[oficina]" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta" >DC / N� Cuenta</td>
 <td><input type="text" name="registro[dc_ccc]" size="2" maxlength="3" class="insertext">
 <input type="text" name="registro[cuenta_bancaria]" class="insertext" size="11" maxlength="10"></td>
</tr>
 <tr>
 <td class="etiqueta">ENTIDAD</td>
 <td><input type="text" name="registro[iban]" size="5" maxlength="4" class="insertext"></td>
 <td class="etiqueta">C�digo Identificador de Banco</td>
 <td><input type="text" name="registro[bic]" size="13" maxlength="12" class="insertext"></td>
 <td class="etiqueta">N�mero de Cuenta Bancaria Base</td>
 <td><input type="text" name="registro[bban]" size="27" maxlength="26" class="insertext"></td>
 </tr>
</table>
</fieldset>
<input type="hidden" name="accion_ejecutar" value="Modificar" />
</form>

<div class="AccionesEnvio"><ul>
<li><a href="" onClick="return sendForm('nuevo_agentes');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Nuevo</span></a></li>
</ul></div>

