<div class="barraoscura">
<div class="titsuperior">&gt; Nouvelle Service</div></div> 

<!--@%Servicios.id_servicio;%@-->
<table class="full">
<form name="nuevo_servicios" action="?seccion=bo_servicios" method="post">
<input type="hidden" name="registro[id_servicio]" value="NULL" />
<input type="hidden" name="estado" value="1" />

<tr><td class="etiqueta">Nom:</td>
<td colspan="4"><input type="text" name="registro[nombre]" size="55" /></td>
 </tr>

<tr><td class="etiqueta">Duré:</td>
<td ><input type="text" name="registro[duracion]" size="5" /></td>
<td><input type="radio" name="registro1" value="d" checked /> Jours </td>
<td><input type="radio" name="registro1" value="m" /> Mois </td>
<td><input type="radio" name="registro1" value="a" /> année </td>
 </tr>

<tr><td class="etiqueta">Délai de facture:</td>
<td ><input type="text" name="registro[plazo_factura]" size="5" /></td>
 <td><input type="radio" name="registro2" value="d" checked />Jours</td>
 <td><input type="radio" name="registro2" value="m" />Mois</td>
 <td><input type="radio" name="registro2" value="a" />année</td>
 </tr>

</table>
<div class="enviar"><a href="javascript:document.forms['nuevo_servicios'].submit();">Garder</a></div>

</form>
