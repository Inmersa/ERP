<div class="barraoscura">
<div class="titsuperior">&gt; Novo Tipo de IVA</div><div class="alinder">
</div></div> 
<table class="full">
<form name="nuevo_tipos_iva" action="?seccion=bo_tipos_iva" method="post">
<input type="hidden" name="registro[id_iva]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr><td class="etiqueta"> Nome:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>

 </tr>

<tr><td class="etiqueta"> Percentagem:</td>
<td><input type="text" name="registro[porcentaje]" size="55" /></td>
 </tr>

<tr><td class="etiqueta">Sobretaxa Equivalente:</td>
<td><input type="text" name="registro[recargo_equivalente]" size="55" /></td>
 </tr>



</table>
<div class="enviar"><a href="javascript:document.forms['nuevo_tipos_iva'].submit();">Guardar</a></div>
</form>

