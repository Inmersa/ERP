
 no puedo... 
 <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="22"></td>
 </tr>
 <tr> <td width="112" bgcolor="#EBECED" class="etiqueta" align="right" height="22">Tipo de agente:</td>
 <td width="532" > <select name="registro[id_tipo_agente]" class="insertext">
 <option value="">-- Ninguna seleccion --</option>
 @%func:obtener_Tipo_agente%@
 <!--@%db:Agentes.id_tipo_agente;%@-->
 @%where:tabla|Tipo_agente;order|Tipo_agente.nombre;nolink|1;%@
 <option value="@%db:Tipo_agente.id_tipo_agente;%@" @%func:chequear_Tipo_agente%@>@%db:Tipo_agente.nombre;%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="1"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="10"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> <td height="22" colspan="4" class="etiqueta"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Nombre:</td>
 <td height="22" class="texto" width="335"> @%db:Agentes.nombre;%@<input type="hidden" name="registro[nombre]" value="@%db:Agentes.nombre;%@" class="insertext" size="30">
 </td>
 <td height="22" class="etiqueta" width="100" bgcolor="#EBECED" align="right">Tel�fono 1:</td>
 <td height="22" class="texto" width="98"> @%db:Agentes.telefono1;%@<input type="hidden" name="registro[telefono1]" value="@%db:Agentes.telefono1;%@" class="insertextnumeros" size="12">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Apellidos:</td>
 <td height="22" class="texto" width="335"> @%db:Agentes.apellidos;%@<input type="hidden" name="registro[apellidos]" value="@%db:Agentes.apellidos;%@" class="insertext" size="30"></td>
 <td height="22" class="etiqueta" bgcolor="#EBECED" width="100" align="right">Tel�fono 2:</td>
 <td height="22" class="texto" width="98"> @%db:Agentes.telefono2;%@<input type="hidden" name="registro[telefono2]" value="@%db:Agentes.telefono2;%@" class="insertextnumeros" size="12">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Direcci�n:</td>
 <td height="22" class="texto" width="335"> @%db:Agentes.direccion;%@<input type="hidden" name="registro[direccion]" value="@%db:Agentes.direccion;%@" class="insertext" size="30">
 </td>
 <td height="22" class="etiqueta" bgcolor="#EBECED" width="100" align="right">Poblaci�n:</td>
 <td height="22" class="texto" width="98"> @%db:Agentes.poblacion;%@<input type="hidden" name="registro[poblacion]" value="@%db:Agentes.poblacion;%@" class="insertext" size="12">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Provincia:</td>
 <td height="22" class="texto" width="335"> 
<select name="registro[id_provincia]" class="insertext">
 <option value="">-- Ninguna seleccion --</option>
 @%func:obtener_provincia%@
 <!--@%db:Agentes.id_provincia;%@-->
 @%where:tabla|Provincias;order|Provincias.nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_provincia%@ >@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select>
 </td> <td height="22" class="etiqueta" bgcolor="#EBECED" width="100" align="right">CP:</td>
 <td height="22" class="texto" width="98"> @%db:Agentes.cp;%@<input type="hidden" name="registro[cp]" value="@%db:Agentes.cp;%@" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
</table>
