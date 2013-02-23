
<form name="nuevo_coordinadores" action="?seccion=bo_coordinadores" method=post>
<div class="barraoscura">
<div class="titsuperior">&gt; NUEVO COORDINADOR</div>
</div>

<fieldset id="Nuevo_Coordinador" class="fsficha">
<legend>Datos de Contacto</legend>
<table class="full">
<tr> 
<td class="etiqueta" >Nombre:</td>
<td ><input type="text" name="registro[nombre]" size="30"></td>
<td class="etiqueta">Apellidos:</td>
<td ><input type="text" name="registro[apellidos]" size="20"></td>
</tr>

<tr> 
<td class="etiqueta" >Dni:</td>
<td ><input type="text" name="registro[dni]" size="20"></td>
<td class="etiqueta" >Login:</td>
<td ><input type="text" name=registro[login] size="30"></td>
</tr>

<tr>
<td class="etiqueta" >Dirección:</td>
<td ><input type="text" name="registro[direccion]" size="30"></td>
<td class="etiqueta" >Pass.:</td>
<td ><input type="password" name=registro[passwd] size="20"></td>
</tr>

<tr>
<td class="etiqueta" >e-mail:</td>
<td ><input type="text" name="registro[email]" size="30"></td>
<td class="etiqueta" >Repetir Pass:</td>
<td ><input type="password" name=registro[passwd2] size="20"></td>
</tr>
</table>


</fieldset>
<div class="enviar"><input 
type="hidden" name="accion_ejecutar" 
value="Nuevo" /><a href="#" 
onClick="return sendForm('nuevo_coordinadores');" >Guardar</a></div>

</form>
