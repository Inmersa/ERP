
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="13"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_paises" action="?seccion=bo_paises" method=post>
 <input type=hidden name=registro[id_pais] value="@%db:Paises.id_pais;%@">
 <input type=hidden name=estado value=1>
 <tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="188" class="etiqueta" align="right" height="22"> <!--@%Paises.id_pais;%@-->
 Name:</td>
 <td width="455" class="texto"> @%db:Paises.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Paises.nombre;%@" class="insertext" size="55">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="188" class="etiqueta" align="right" height="22">Code:</td>
 <td width="455" class="texto"> @%db:Paises.codigo;%@
<input type="hidden" name="registro[codigo]" size="5" value="@%db:Paises.codigo;%@" class="insertext">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="188" class="etiqueta" align="right" height="22">Continent:</td>
 <td width="455" class="texto"> @%db:Paises.continente;%@
<input type="hidden" name="registro[continente]" size="55" value="@%db:Paises.continente;%@" class="insertext">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="188" class="etiqueta" align="right" height="22">Prefix Tf.:</td>
 <td width="455" class="texto"> <b> @%db:Paises.prefijo_tlf;%@
<input type="hidden" name="registro[prefijo_tlf]" size="5" value="@%db:Paises.prefijo_tlf;%@" class="insertext">
 </b> </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="3" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="188" class="etiqueta" align="right" height="22">Prefix EIN: </td>
 <td width="455" class="texto"> @%db:Paises.prefijo_cif;%@
<input type="hidden" name="registro[prefijo_cif]" size="5" value="@%db:Paises.prefijo_cif;%@" class="insertext">
 </td>
 <td width="2" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="188" bgcolor="#CCD2D7"></td>
 <td height="1" width="455" bgcolor="#CCD2D7"></td>
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

