 <table width="647" border="0" cellspacing="0" cellpadding="0">

 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr bgcolor="#CCD2D7"> <td colspan="2" height="22"></td>
 </tr>
 <tr> <td width="112" bgcolor="#EBECED" class="etiqueta" align="right" height="22">Tipo de Agente:</td>
 <td width="532" > <select name="registro[id_tipo_agente]" class="insertext">
 <option value="">N�o Existem Itens Seleccionados</option>
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
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Nome:</td>
 <td height="22" class="texto" width="335"> <input type="text" name="registro[nombre]" value="@%db:Agentes.nombre;%@" class="insertext" size="30">
 </td>
 <td height="22" class="etiqueta" width="100" bgcolor="#EBECED" align="right">Telefone 1:</td>
 <td height="22" class="texto" width="98"> <input type="text" name="registro[telefono1]" value="@%db:Agentes.telefono1;%@" class="insertextnumeros" size="12">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Apelidos:</td>
 <td height="22" class="texto" width="335"> <input type="text" name="registro[apellidos]" value="@%db:Agentes.apellidos;%@" class="insertext" size="30"></td>
 <td height="22" class="etiqueta" bgcolor="#EBECED" width="100" align="right">Telefone 2:</td>
 <td height="22" class="texto" width="98"> <input type="text" name="registro[telefono2]" value="@%db:Agentes.telefono2;%@" class="insertextnumeros" size="12">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Endere�o:</td>
 <td height="22" class="texto" width="335"> <input type="text" name="registro[direccion]" value="@%db:Agentes.direccion;%@" class="insertext" size="30">
 </td>
 <td height="22" class="etiqueta" bgcolor="#EBECED" width="100" align="right">Localidade:</td>
 <td height="22" class="texto" width="98"> <input type="text" name="registro[poblacion]" value="@%db:Agentes.poblacion;%@" class="insertext" size="12">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="111">Distrito:</td>
 <td height="22" class="texto" width="335"> 
<select name="registro[id_provincia]" class="insertext">
 <option value="">N�o Existem Itens Seleccionados</option>
 @%func:obtener_provincia%@
 <!--@%db:Agentes.id_provincia;%@-->
 @%where:tabla|Provincias;order|Provincias.nombre;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_provincia%@ >@%db:Provincias.nombre;%@</option>
 @%end-where:%@

</select>
 </td> <td height="22" class="etiqueta" bgcolor="#EBECED" width="100" align="right">CP:</td>
 <td height="22" class="texto" width="98"> <input type="text" name="registro[cp]" value="@%db:Agentes.cp;%@" class="insertextnumeros" size="6">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
</table>