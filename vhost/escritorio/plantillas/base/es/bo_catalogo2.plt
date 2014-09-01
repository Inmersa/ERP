 @%plt:buscador%@ 
<table width="702" border="0" cellspacing="0" cellpadding="0" bordercolor="#3F4D83">
 <tr align="center"> <td class="bordes"> <table width="600" border="0" cellspacing="0" cellpadding="0">
 <br>
 <tr>
 @%where:tabla|Catalogo_imagenes;nombre|busc;%@ 
 @%if:contador%@
 </tr>
 <tr>
 @%end-if:%@
 <td width="230" align="center"> <table width="191" border="0" cellspacing="0" cellpadding="0">
 <tr align="center"> <td height="130" class="bordes">
 <img src="../@%func:img_dir%@@%db:Catalogo_imagenes.nombre%@" width="180" height="120"></td>
 </tr>
 <tr align="left"> <td> <br>
 <table width="48" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="bordes">
 <a href="?seccion=bo_elegir_cat&amp;id_imagen=@%db:Catalogo_imagenes.id_imagen%@" class="texto_negrita_sinfondo">Modificar</a></td>
 </tr>
 <tr>
 <td heigth=5></td>
 </table>
 <table width="48" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td class="bordes">
 <a href="?seccion=bo_catalogo&id_imagen=@%db:Catalogo_imagenes.id_imagen%@&nombre_foto=@%db:Catalogo_imagenes.nombre%@&estado=2"
 onclick="return confirm('Esta ud. seguro de que de desea borrar el registro?');return false;">
 Borrar</a></td>
 </tr>
 </table>
 <br>
 </td>
 </tr>
 </table>
 </td>
 @%end-where:%@

 </tr>
 </table>
 </td>
 </tr>
</table>

@%plt:botonera%@


