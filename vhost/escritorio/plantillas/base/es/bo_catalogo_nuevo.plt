<!--ficha de imagenes--><br>
<form method="post" ENCTYPE="multipart/form-data"
 action="?seccion=bo_catalogo&estado=1" name="form_ficha">
 <table width="530" cellspacing="0" cellpadding="0" bordercolor="#3F4D83">
 <tr> <td width="29" rowspan="8"></td>
 <td colspan="2"> <table width="350" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="8"></td>
 </tr>
 </table>
 <table border="0" cellspacing="0" cellpadding="0" height="17" bordercolor="#FFFFFF" width="454">
 <tr> <td class="titulo_seccion" height="2" width="218" valign="middle"> <div align="center"><font color="#FFFFFF">Ficha de imagen</font></div>
 </td>
 <td width="123" bgcolor="#FFFFFF" height="2" class="titulo_seccion_der" valign="middle"></td>
 <td width="113" bgcolor="#FFFFFF" height="2" align="right">
 <span class="bordesbot"><a href="" onclick="window.close()">Cerrar</a></span> </td>
 </tr>
 </table>
 <br>
 </td>
 </tr>
 <tr> <td class="texto_negrita_sinfondo" height="33" colspan="2">Autor: <input height="20" size="49"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[autor]">
 </td>
 </tr>
 <tr> <td height="110" colspan="2"> <table width="394" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="81" class="texto_negrita_sinfondo" height="48">Copyright: </td>
 <td width="118" class="texto_negrita_sinfondo" height="48" align="right"> <input height="20" size="20"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[copyright]">
 </td>
 <td width="195" rowspan="3" align="center">
 <img src="../@%func:img_dir%@logo.gif" width="150" height="100" class="bordes"></td>
 </tr>
 <tr> <td height="6" colspan="2"> </td>
 </tr>
 <tr> <td width="81" class="texto_negrita_sinfondo" height="23">Fecha: </td>
 <td class="texto_negrita_sinfondo" height="23" align="right" width="118"> <input height="20" size="10"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[fecha_toma]" value="dd/mm/aaaa">
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="2" class="texto_negrita_sinfondo"> Localización: <input height="20" size="44"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[lugar_toma]">
 </td>
 </tr>
 <tr> <td class="texto_negrita_sinfondo" colspan="2" height="22">Palabras clave: <input height="20" size="42"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[palabras_clave]">
 </td>
 </tr>
 <tr>
 <td class="texto_negrita_sinfondo" colspan="2" height="22">Pie de foto:
 <input height="20" size="42"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[descripcion]">
 </td>
 </tr>
 <tr>
 <td class="texto_negrita_sinfondo" colspan="2" height="22">
 <input type=hidden name="registro[en_portada]">
 </td>
 </tr>
 <tr> <td class="texto_negrita_sinfondo" width="314" height="22"> Imagen: <input height="20" size="30"
 type="file"
 style="border: 2 #989898 solid; height: 23;"
 name="foto">
 </td>
 </tr>
 <tr> <td class="maslink" colspan="2" height="7"></td>
 </tr>
 </table>
 <table width="529" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="267" align="center" height="30"> </td>
 <td width="81" align="center" height="30"> <table width="60" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="bordes"><a href="javascript:document.form_ficha.submit()" class="texto_negrita_sinfondo">Guardar</a></td>
 </tr>
 </table>
 </td>
 <td width="181" height="30"> <table width="129" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="bordes"><a href="javascript:document.form_ficha.reset()" class="texto_negrita_sinfondo">Deshacer Cambios</a></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
</form>
<!--fin ficha de imagenes --> 
