<div class="barraoscura">
<div class="titsuperior">&gt; Nouveau Type de client</div></div> 


<form name="nuevo_tipo_cliente" action="?seccion=bo_tipo_cliente" method="post">
<input type="hidden" name="registro[id_tipo_cliente]" value="NULL" />
<input type="hidden" name="estado" value="1" />
<table class="full">
<tr><td class="etiqueta">Nom:</td>
<td><input type="text" name="registro[nombre]" size="40" /></td>
 </tr>
<tr><td class="etiqueta">Description:</td>
<td><input type="text" name="registro[descripcion]" size="70" /></td>

 </tr>
<tr><td class="etiqueta">TVA:</td>
<td><input type="checkbox" name="registro[aplicar_iva]" value="1" /></td>

 </tr>
<tr><td class="etiqueta">Reteneu �quivalent:</td>
<td><input type="checkbox" name="registro[aplicar_recargo]" value="1" /></td>
</tr>

</table>
<div class="enviar"><a href="#" onClick="return sendForm('nuevo_tipo_cliente');">Garder</a></div>
</form>

