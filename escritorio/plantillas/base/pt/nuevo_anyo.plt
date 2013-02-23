
<form name="nuevo_anyo" accion="?secicon=cfg_anyos" method="post" >
<input type="hidden" name="accion_ejecutar" value="Nuevo" />

<fieldset class="fsficha">
<legend>Novo Ano</legend>

<div class="AccionesFicha"><ul>
<li><a href="#" onClick="return sendForm('nuevo_anyo');" class="nuevo" 
><img src="imag/pixel.png" class="icono" /><span>Novo</span></a></li>
</ul></div>

<table class="full">
<thead><tr>
<td >Número</td>
<td >Nome</td>
<td >Número de Trimestres</td>
</tr></thead>

<tbody>
<tr>
 <td><input type="text" name="nuevo_anyo[numero]" value="" class="mininum" /></td>
 <td><input type="text" name="nuevo_anyo[nombre]" value="" class="texto" /></td>
 <td><select name="nuevo_anyo[n_trimestres]" >
 <option value="1">1</option>
 <option value="2">2</option>
 <option value="3">3</option>
 <option value="4" selected="selected" >4</option>
 </select></td>
</tr>
</tbody></table>
</fieldset>
</form>

