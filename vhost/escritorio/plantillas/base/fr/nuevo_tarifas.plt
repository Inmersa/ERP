<div class="barraoscura">
<div class="titsuperior">&gt; Nouvelle tarif</div></div> 

<table class="full">
<form name="nuevo_tarifas" action="?seccion=bo_tarifas" method="post">
<input type="hidden" name="registro[id_tarifa]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr><td class="etiqueta"> Nom:</td>
<td><input type="text" name="registro[nombre]" size="55" /></td>
<td rowspan="5"></td>
 </tr>

<tr><td class="etiqueta">% Premièr:</td>
<td><input type="text" name="registro[pto_primero]" size="55" /></td>
 </tr>

<tr><td class="etiqueta">% Seconde:</td>
<td><input type="text" name="registro[pto_segundo]" size="55" /></td>
 </tr>

<tr><td class="etiqueta">Montant:</td>
<td><input type="text" name="registro[monto]" size="55" /></td>
</tr>

</table>
<div class="enviar"><a href="javascript:document.forms['nuevo_tarifas'].submit();">Garder</a></div>
</form>

