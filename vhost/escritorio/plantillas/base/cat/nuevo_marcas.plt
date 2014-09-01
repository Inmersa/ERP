
 <div class="barraoscura"><div class="titsuperior">&gt; Nova Marca</div></div>

<form name="nuevo_marcas" action="?seccion=bo_marcas" method="post">
<input type="hidden" name="registro[id_marca]" value="NULL">
<input type="hidden" name="estado" value="1">
<table class="full">
 <tr>
 <td class="etiqueta" >Nom:</td>
 <td ><input type="text" name="registro[nombre]" size="55"></td>
 </tr>
 <tr><td class="etiqueta" >Observacions:</td>
 <td ><input type="text" name="registro[observaciones]" size="55"></td>
 </tr>
</table>
</form>
 <div class="enviar"><a href="#" onClick="return sendForm('nuevo_marcas');" >Guardar</a></div>
