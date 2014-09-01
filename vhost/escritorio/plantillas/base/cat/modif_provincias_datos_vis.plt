
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_provincias" action="" method=post>
 <input type=hidden name=registro[id_provincia] value="@%db:Provincias.id_provincia;%@">
 <input type=hidden name=estado value=1>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="22"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="219" class="etiqueta" align="right" height="22"> <!--@%Provincias.id_provincia;%@-->
 Nom:</td>
 <td width="424" class="texto"> @%db:Provincias.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Provincias.nombre;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="219"></td>
 <td bgcolor="#CCD2D7" width="424"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="219" class="etiqueta" align="right" height="22">Països:</td>
 <td width="424"> <select name="registro[id_pais]" class="insertext">
@%func:obtener_Paises%@
 <!--@%db:Provincias.id_pais;%@-->
@%where:tabla|Paises;nolink|1;%@
 <option value="@%db:Paises.id_pais;%@" @%func:chequear_Paises%@> @%db:Paises.nombre;%@ </option>
@%end-where:%@
 </select>
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="219" class="etiqueta" align="right" height="22">Codi:</td>
 <td width="424" class="texto"> @%db:Provincias.codigo;%@
<input type="hidden" name="registro[codigo]" size="5" class="insertext" value="@%db:Provincias.codigo;%@">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="219" class="etiqueta" align="right" height="22">Prefix Tf.:</td>
 <td width="424" class="texto"> @%db:Provincias.prefijo_tlf;%@
<input type="hidden" name="registro[prefijo_tlf]" size="5" class="insertext" value="@%db:Provincias.prefijo_tlf;%@">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="219" bgcolor="#CCD2D7"></td>
 <td height="1" width="424" bgcolor="#CCD2D7"></td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"> </td>
 </tr>
</table>
