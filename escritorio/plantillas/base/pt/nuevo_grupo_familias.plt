<div class="barraoscura">
<div class="titsuperior">&gt; Novo Grupo de Fam�lias</div></div>
<table class="full">
<form name="nuevo_grupo_familias" action="?seccion=bo_grupo_familias" method="post">
<input type=hidden name="registro[id_grupo_familia]" value="NULL" />
<input type=hidden name="estado" value="1" />

<tr>
<td class="etiqueta">Nome:</td>
<td><input type="text" name="registro[nombre]" size="40" /></td>
</tr>
<tr><td class="etiqueta">Descri��o:</td>
<td><input type="text" name="registro[descripcion]" size="65" /></td>
</tr>

</form>
</table>

<div class="enviar"><a href="javascript:document.forms['nuevo_grupo_familias'].submit();">Guardar</a></div>