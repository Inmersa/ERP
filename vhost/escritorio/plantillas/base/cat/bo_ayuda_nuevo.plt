 <div class="barraoscura"><div class="titsuperior">&gt; Nova Ajuda</div></div>
 <form name="nuevo_ayuda" action="?seccion=bo_ayuda" method="post">
 <input type="hidden" name="estado" value="1">
 <table class="full">
 <tr><td class="etiqueta" >Secci�:</td>
 <td ><select name="registro[id_sub]" class="insertext" >
 @%where:db|conf;tabla|Sub_Secc;nolink|1;where|backoffice = 1;%@
 <option value="@%db:Sub_Secc.id_sub_secc;%@">@%db:Sub_Secc.nombre_visual;%@(@%db:Sub_Secc.nombre%@)</option>
 @%end-where:%@

 </select>
 </td>
 <tr><td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" class="insertext" size="40"></td>
 </tr>
 <tr><td class="etiqueta" >Avant�tol:</td>
 <td ><input type="text" name="registro[antetitulo]" class="insertext" size="65"></td>
 </tr>
 <tr><td class="etiqueta" >T�tol:</td>
 <td ><input type="text" name="registro[titulo]" class="insertext" size="65"></td>
 </tr>
 <tr><td class="etiqueta" >Actiu:</td>
 <td ><input type="checkbox" name="registro[activo]" class="insertext" value="1"></td>
 </tr>
 <tr><td class="etiqueta" >Cos:{{bo_ayuda_nuevo.plt8}}</td>
 <td ><textarea name="registro[cuerpo]" class="insertext" cols="80"></textarea></td>
 </tr>
 </table>
 </form>

 <div class="enviar"><a href="#" onClick="return sendForm('nuevo_ayuda');" >Guardar</a> </div>
