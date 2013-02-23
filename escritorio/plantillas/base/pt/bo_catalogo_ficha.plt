 @%where:db|db_catalogo;tabla|Catalogo_imagenes%@
<!--ficha de imagenes--><br>
<form method="post" ENCTYPE="multipart/form-data"
 action="?seccion=bo_catalogo&modificado=1&id_imagen=@%db:Catalogo_imagenes.id_imagen%@&llamada=1"
 name="form_ficha">
 <table width="530" cellspacing="0" cellpadding="0" bordercolor="#3F4D83">
 <tr> <td width="29" rowspan="7"></td>
 <td colspan="2"> <table width="350" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="8"></td>
 </tr>
 </table>
 <table border="0" cellspacing="0" cellpadding="0" height="17" bordercolor="#FFFFFF" width="454">
 <tr> <td class="titulo_seccion" height="2" width="218" valign="middle"> <div align="center"><font color="#FFFFFF">Ficha de Imagem</font></div>
 </td>
 <td width="123" bgcolor="#FFFFFF" height="2" class="titulo_seccion_der" valign="middle"></td>
 <td width="113" bgcolor="#FFFFFF" height="2" align="right"><span class="bordesbot">
 <a href="" onclick="window.close()">Fechar</a></span> </td>
 </tr>
 </table>
 <br>
 </td>
 </tr>
 <tr> <td class="texto_negrita_sinfondo" height="33" colspan="2">Responsável: <input height="20" size="49"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[autor]" value="@%db:Catalogo_imagenes.autor%@">
 </td>
 </tr>
 <tr> <td height="110" colspan="2"> <table width="394" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="81" class="texto_negrita_sinfondo" height="48">Direitos de Autor: </td>
 <td width="118" class="texto_negrita_sinfondo" height="48" align="right"> <input height="20" size="20"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[copyright]" value="@%db:Catalogo_imagenes.copyright%@">
 </td>
 <td width="195" rowspan="3" align="center">
 <img src="../@%func:img_dir%@@%db:Catalogo_imagenes.nombre%@" width="150" height="100" class="bordes"></td>
 </tr>
 <tr> <td height="6" colspan="2"> </td>
 </tr>
 <tr> <td width="81" class="texto_negrita_sinfondo" height="23">Data: </td>
 <td class="texto_negrita_sinfondo" height="23" align="right" width="118"> <input height="20" size="10"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[fecha_toma]" value="@%db:barras_fecha{Catalogo_imagenes.fecha_toma}%@">
 </td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td colspan="2" class="texto_negrita_sinfondo"> Localização: <input height="20" size="44"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[lugar_toma]" value="@%db:Catalogo_imagenes.lugar_toma%@">
 </td>
 </tr>
 <tr> <td class="texto_negrita_sinfondo" colspan="2" height="22">Palavras-Chave: <input height="20" size="42"
 type="text"
 style="border: 2 #989898 solid; height: 23;"
 name="registro[palabras_clave]" value="@%db:Catalogo_imagenes.palabras_clave%@">
 </td>
 </tr>
 <tr> <td class="maslink" colspan="2" height="7"></td>
 </tr>
 </table>
 <table width="529" border="0" cellspacing="0" cellpadding="0">
 <tr> <td width="267" align="center" height="30"> </td>
 <td width="81" align="center" height="30"> <table width="60" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="bordes"><a href="" onclick="history.go(-1); return false;" class="texto_negrita_sinfondo">Voltar</a></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 <input type=hidden name="registro[id_imagen]" value="@%db:Catalogo_imagenes.id_imagen%@">
 <input type=hidden name="apoyo" value="@%db:Catalogo_imagenes.nombre%@">
</form>
<!--fin ficha de imagenes --> 
@%end-where:%@
