<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td height="30"> <table width="644" border="0" cellspacing="0" cellpadding="0">
<form name="modif_transportistas" action="?seccion=bo_transportistas" method=post>
<input type=hidden name=registro[id_transportista] value="@%db:Transportistas.id_transportista;%@">
<input type=hidden name=estado value=1>
<!--@%Transportistas.id_transportista;%@-->
 <tr> <td colspan="4" height="22" bgcolor="#CCD2D7"> </td>
 </tr>
 <tr align="center"> <td colspan="4" height="22" > <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="etiqueta" height="22">Nome:</td>
 <td width="228"> <input type="text" name="registro[nombre]" value="@%db:Transportistas.nombre;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" align="right" class="etiqueta">Apelidos:</td>
 <td width="168"> <input type="text" name="textfield2233382" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Denominação Comercial:</td>
 <td width="228"> <input type="text" name="registro[razon_social]" value="@%db:Transportistas.razon_social;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">CIF:</td>
 <td width="168"> <input type="text" name="textfield2233383" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td width="161" class="etiqueta" align="right" height="22" bgcolor="#EBECED">Endereço:</td>
 <td width="228"> <input type="text" name="registro[direccion]" value="@%db:Transportistas.direccion;%@" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Localidade:</td>
 <td width="168"> <input type="text" name="textfield2233384" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Distrito:</td>
 <td width="228"> <select name="registro[id_provincia]" class="insertext">
@%func:obtener_Provincias%@
 <!--@%db:Transportistas.id_provincia;%@-->
@%where:tabla|Provincias;nolink|1;%@
 <option value="@%db:Provincias.id_provincia;%@" @%func:chequear_Provincias%@> @%db:Provincias.nombre;%@ </option>

 @%end-where:%@

 </select>
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">CP:</td>
 <td width="168"> <input type="text" name="registro[cp]" value="@%db:Transportistas.cp;%@" class="insertextnumeros" size="5">
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td colspan="4" align="right" class="etiqueta" height="22"></td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td width="161" height="22" bgcolor="#EBECED" class="etiqueta" align="right">IBAN:</td>
 <td width="228"> <input type="text" name="textfield2233362" class="insertext" size="30">
 </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Telefone 1:</td>
 <td width="168"> <input type="text" name="registro[telefono]" value="@%db:Transportistas.telefono;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7" ></td>
 </tr>
 <tr> <td width="161" height="22" bgcolor="#EBECED" class="etiqueta" align="right"></td>
 <td rowspan="5" valign="top"> </td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Telefone 2:</td>
 <td width="168"> <input type="text" name="textfield22333872" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td width="161" height="22" class="etiqueta" align="right" bgcolor="#EBECED"></td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">Fax:</td>
 <td width="168"> <input type="text" name="registro[fax]" value="@%db:Transportistas.fax;%@" class="insertextnumeros" size="14">
 </td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td width="161" height="22" class="etiqueta" align="right" bgcolor="#EBECED"></td>
 <td bgcolor="#EBECED" width="87" class="etiqueta" align="right">e-mail:</td>
 <td width="168"> <input type="text" name="registro[email]" value="@%db:Transportistas.email;%@" class="insertext" size="20">
 </td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr align="center"> <td colspan="4" height="22" ></td>
 </tr>
 <tr bgcolor="#CCD2D7" align="center"> <td colspan="4" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"></td>
 </tr>
</table>
