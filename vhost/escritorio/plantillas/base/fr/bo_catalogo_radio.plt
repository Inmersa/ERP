
 @%plt:categorias%@
 <br>
 @%plt:subcategorias%@
 <br>
 @%plt:buscador%@
 <br>
<table width="726" border="0" cellspacing="0" cellpadding="0" bordercolor="#3F4D83">
 <tr align="center"> <td class="tabla_escalafon_der"> <table width="700" border="0" cellspacing="0" cellpadding="0">
 <br>
 <tr>
 <form action="#" method=post name="form_cat_radio">
 @%where:tabla|Catalogo_imagenes;nombre|busc;%@ 
 @%if:contador%@
 </tr>
 <tr>
 @%end-if:%@
 <td width="230" align="center"> <table width="191" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td height="130" class="bordes">
 <img src="/@%func:img_dir%@@%db:Catalogo_imagenes.nombre%@" width="180" height="120"></td>
 </tr>
 <tr align="left"> <td> <br>
 <input type="radio" name="las_fotos" value="@%db:Catalogo_imagenes.id_imagen%@">
 <span class="maslink">Sélectionner</span> <table width="76" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="bordes">
 <a href="?seccion=bo_catalogo_ficha&id_imagen=@%db:Catalogo_imagenes.id_imagen%@" class="texto_negrita_sinfondo">Voir </a></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr align="center">
 <td height="10">
 </tr>
 </table>
 </td>
 @%end-where:%@

 </form>
 </tr>
 </table>
 <table width="700" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="24">
 <table width="61" border="0" cellspacing="0" cellpadding="0" align="right">
 <tr>
 <td class="bordes"><a href="javascript:document.form_cat_radio.submit()" class="texto_negrita_sinfondo">Accepter</a></td>
 </tr>
 </table>
 </td>
 </tr>
 </table>
 <br>
 </td>
 </tr>
</table>

 @%plt:botonera%@

