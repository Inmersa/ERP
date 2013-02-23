
 <div class="barraoscura"><div class="titsuperior">&gt; Noveau epigraphe d´aide @%get:ayuda_nombre_visual%@(@%get:ayuda_nombre%@)</div></div>
 <form name="nuevo_ayuda" action="?seccion=bo_ayuda_modif&id_sub=@%get:ayuda_id%@" method="post">
 <input type="hidden" name="estado" value="3">
 <input type="hidden" name="registro[id_sub]" value="@%get:ayuda_id%@">
<table class="full">
 <tr><td class="etiqueta">Titre:</td>
 <td ><input type="text" name="registro[titulo]" class="insertext" size="65"></td>
 </tr>
 <tr><td class="etiqueta" >Actif:</td>
 <td ><input type="checkbox" name="registro[activo]" class="insertext" value="1"></td>
 </tr>
 <tr><td class="etiqueta" >Corp:</td>
 <td ><textarea name="registro[cuerpo]" class="insertext" cols="80"></textarea></td>
 </tr>
 </table>
 </form>
 <div class="enviar"><a href="#" onClick="return sendForm('nuevo_ayuda');" >Garder</a></div>
