
 <div class="barraoscura"><div class="titsuperior">&gt; NUEVO EPIGRAFE de AYUDA para @%get:ayuda_nombre_visual%@(@%get:ayuda_nombre%@)</div></div>
 <form name="nuevo_ayuda" action="?seccion=bo_ayuda_modif&id_sub=@%get:ayuda_id%@" method="post">
 <input type="hidden" name="estado" value="3">
 <input type="hidden" name="registro[id_sub]" value="@%get:ayuda_id%@">
<table class="full">
 <tr><td class="etiqueta">Título:</td>
 <td ><input type="text" name="registro[titulo]" class="insertext" size="65"></td>
 </tr>
 <tr><td class="etiqueta" >Activo:</td>
 <td ><input type="checkbox" name="registro[activo]" class="insertext" value="1"></td>
 </tr>
 <tr><td class="etiqueta" >Cuerpo:</td>
 <td ><textarea name="registro[cuerpo]" class="insertext" cols="80"></textarea></td>
 </tr>
 </table>
 </form>
 <div class="enviar"><a href="#" onClick="return sendForm('nuevo_ayuda');" >Guardar</a></div>
