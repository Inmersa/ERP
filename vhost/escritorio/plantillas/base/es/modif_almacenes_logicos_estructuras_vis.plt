@%where:tabla|Almacenes_logicos;where|Almacenes_logicos.id_almacen = $id_almacen_logico_promocion;%@

<table width="647" border="0">
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="modif_almacenes_logicos" action="?seccion=modif_almacenes_logicos&id_almacen_logico=@%db:Almacenes_logicos.id_almacen_logico;%@" method=post>
<input type=hidden name=registro[id_almacen_logico] value="@%db:Almacenes_logicos.id_almacen_logico;%@">
 <tr> <td colspan="4" height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td width="80" bgcolor="#EBECED" align="right" class="etiqueta" height="22">Nombre:</td>
 <td width="3" bgcolor="#EBECED"></td>
 <td class="texto"> @%db:Almacenes_logicos.nombre;%@
<input type="hidden" name="registro[nombre]" value="@%db:Almacenes_logicos.nombre;%@" class="insertext" size="80">
 </td>
 <td bgcolor="#CCD2D7" width="1"></td>
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="4" height="1"></td>
 </tr>
 <tr align="center"> <td bgcolor="#EBECED" class="etiqueta" align="right" height="22">Plantas:</td>
 <td bgcolor="#EBECED" class="etiqueta"></td>
 <td class="etiqueta">
 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="etiqueta">
 <tr>
 <td>
 @%db:Almacenes_logicos.n_planta;%@<input type="hidden" name="registro[n_planta]" value="@%db:Almacenes_logicos.n_planta;%@" class="insertext" size="3">
 </td>
 <td align="right" bgcolor="#EBECED" width="80">Pasillos:</td>
 <td>
 @%db:Almacenes_logicos.n_pasillo;%@<input type="hidden" name="registro[n_pasillo]" value="@%db:Almacenes_logicos.n_pasillo;%@" class="insertext" size="3">
 </td>
 <td align="right" bgcolor="#EBECED" width="80">Filas:</td>
 <td>
 @%db:Almacenes_logicos.n_fila;%@<input type="hidden" name="registro[n_fila]" value="@%db:Almacenes_logicos.n_fila;%@" class="insertext" size="3">
 </td>
 <td bgcolor="#EBECED" align="right" width="80">Columnas:</td>
 <td>
 @%db:Almacenes_logicos.n_columna;%@<input type="hidden" name="registro[n_columna]" value="@%db:Almacenes_logicos.n_columna;%@" class="insertext" size="3">
 </td>
 </tr>
 </table>
 </td>
 <td class="etiqueta" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr align="center"> <td colspan="4" height="22" bgcolor="#CCD2D7"> 
 </td>
 </tr>
 </form>
</table>
</td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="25"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="21">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="21" width="6" bgcolor="#CCD2D7"> </td>
 <td height="21" bgcolor="#CCD2D7" width="128" class="etiqueta">Almacenes</td>
 <td height="21" bgcolor="#CCD2D7" width="4"></td>
 <td height="21" align="right" bgcolor="#CCD2D7" width="234"></td>
 <td height="21" align="right" bgcolor="#CCD2D7" colspan="3"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" colspan="2">Nombre:</td>
 <td height="22" width="4" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" colspan="4" class="texto">@%db:Almacenes.nombre;%@</td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" colspan="2">Dirección:</td>
 <td height="22" width="4" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" colspan="4" class="texto">@%db:Almacenes.direccion;%@ -
@%db:Almacenes.cp;%@ (@%db:Almacenes.poblacion;%@)</td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" colspan="7" bgcolor="#FFFFFF" ></td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" colspan="2">Persona de contacto:</td>
 <td height="22" width="4" bgcolor="#EBECED" align="right" class="etiqueta"></td>
 <td height="22" width="234" class="texto">@%db:Almacenes.persona_contacto;%@ 
(@%db:Almacenes.cargo_persona_contacto;%@)</td>
 <td height="22" width="86" bgcolor="#EBECED" align="right" class="etiqueta">Teléfono:</td>
 <td height="22" width="6" bgcolor="#EBECED"></td>
 <td height="22" width="180"> <p class="texto">@%db:Almacenes.telefono;%@</p>
 </td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF" colspan="4"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="86">Fax:</td>
 <td height="22" width="6" bgcolor="#EBECED"></td>
 <td height="22" width="180" class="texto">@%db:Almacenes.fax;%@</td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF" colspan="4"></td>
 <td height="22" bgcolor="#EBECED" align="right" class="etiqueta" width="86">e-mail:</td>
 <td height="22" width="6" bgcolor="#EBECED"></td>
 <td height="22" width="180" class="texto">@%db:Almacenes.email;%@</td>
 </tr>
 <tr> <td colspan="7" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr>
 <td bgcolor="#FFFFFF" height="30"></td>
 </tr>
 </table>
 