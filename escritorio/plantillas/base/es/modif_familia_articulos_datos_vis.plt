 @%where:tabla|Familia_articulos;%@

<table width="647" border="0" cellspacing="0" cellpadding="0">
<tr> <td bgcolor="#FFFFFF"> <table width="645" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_familia_articulos" action="?seccion=bo_familia_articulos" method=post>
 <input type=hidden name=registro[id_familia] value="@%db:Familia_articulos.id_familia;%@">
 <input type=hidden name=estado value=1>
 <tr> <td colspan="3" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Nombre:</td>
 <td width="316" class="texto"> <!--@%Familia_articulos.id_familia;%@-->
 @%db:Familia_articulos.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Familia_articulos.nombre;%@" class="insertext" size="55">
 </td>
 <td rowspan="5" width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" width="161" bgcolor="#CCD2D7"></td>
 <td height="1" width="316" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" class="etiqueta" align="right" height="22">Stock:</td>
 <td width="316"> <!--@%db:Familia_articulos.stock%@-->
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" height="1" width="161"></td>
 <td bgcolor="#CCD2D7" height="1" width="316"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="etiqueta" height="22">Materia prima:</td>
 <td width="316"> <!--@%db:Familia_articulos.materia_prima%@-->
 </td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="161" align="right" class="etiqueta" height="1"></td>
 <td width="316" bgcolor="#CCD2D7"></td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr>
 <td bgcolor="#CCD2D7" width="161" align="right" class="etiqueta" height="1"></td>
 <td width="316" bgcolor="#CCD2D7"></td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" width="161" align="right" class="etiqueta" height="22">Grupo de familia:</td>
 <td width="316"> <select name="registro[id_grupo_familia]" class="insertext">
 <option value="">-- Ninguna seleccion --</option>

 @%func:obtener_Grupo_familias%@

 <!--@%db:Familia_articulos.id_grupo_familia;%@-->


 @%where:tabla|Grupo_familias;nolink|1;%@
 <option value="@%db:Grupo_familias.id_grupo_familia;%@" @%func:chequear_Grupo_familias%@> @%db:Grupo_familias.nombre;%@ </option>
 @%end-where:%@

 </select>
 </td>
 <td width="1" bgcolor="#CCCCCC"></td>
 </tr>
 <tr> <td height="1" bgcolor="#CCD2D7" width="161"></td>
 <td height="1" bgcolor="#CCD2D7" width="316"></td>
 <td height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" colspan="3"></td>
 </tr>
 <tr align="center"> <td height="22" bgcolor="#CCD2D7" colspan="3"> </td>
 </tr>
 </form>
 </table>
 </td>
 </tr>
 <tr> <td height="30"></td>
 </tr>
</table>