
<form name="nuevo" action="?seccion=operadores" method="post" >

<fieldset id="NuevoOperador" class="fsficha">
<legend>Novo Operador</legend>
<table class="full">
<tr> 
<td class="etiqueta" >Nome:</td>
<td ><input type="text" name="operadores[nombre]" size="30"></td>
<td class="etiqueta">Apelidos:</td>
<td ><input type="text" name="operadores[apellidos]" size="20"></td>
</tr>

<tr> 
<td class="etiqueta" >Dni:</td>
<td ><input type="text" name="operadores[dni]" size="20"></td>
<td class="etiqueta" >Iniciar Sessão:</td>
<td ><input type="text" name=operadores[login] size="30"></td>
</tr>

<tr>
<td class="etiqueta" >Endereço:</td>
<td ><input type="text" name="operadores[direccion]" size="30"></td>
<td class="etiqueta" >Palavra-Passe:</td>
<td ><input type="password" name=operadores[passwd] size="20"></td>
</tr>

<tr>
<td class="etiqueta" >e-mail:</td>
<td ><input type="text" name="operadores[email]" size="30"></td>
<td class="etiqueta" >Repetir a Palavra-Passe:</td>
<td ><input type="password" name=operadores[passwd2] size="20"></td>
</tr>
</table>


</fieldset>
<input type="hidden" name="accion_ejecutar" value="Nuevo" />
<div class="AccionesEnvio">
<ul>
<li><a href="#" onClick="return sendForm('nuevo');" class="guardar" ><img src="imag/pixel.png" class="icono" /><span>Guardar</span></a></li>
</ul>
</div>

</form>
