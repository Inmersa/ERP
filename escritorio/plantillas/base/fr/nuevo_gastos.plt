<div class="barraoscura">
<div class="titsuperior">&gt; Nouveau Dépenses</div><div class="alinder">
</div></div> 
 <form name="nuevo_gastos" action="?seccion=bo_gastos" method="post">
 <input type="hidden" name="estado" value="1" />
<table class="full">
<tr><td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" size="40" /></td></tr>
<tr><td class="etiqueta">Description:</td>
<td><textarea name="registro[descripcion]" cols="75" rows="7"></textarea></td>
 </tr>
</table>
<div class="enviar"><a href="#" onClick="return sendForm('nuevo_gastos');">Garder</a></div>
</form>

