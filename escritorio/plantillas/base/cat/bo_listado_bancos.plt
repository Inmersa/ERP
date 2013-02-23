<div class="barraoscura">
<div class="titsuperior">&gt; Bancs d´empresa</div><div class="alinder">
<a href="?seccion=nuevo_banco">Nou</a>
<a href="javascript:document.forms['listado_bancos'].submit();">Esborrar</a>
</div></div> 

<form name="listado_bancos" action="?seccion=bo_bancos" method="post">
<input type="hidden" name="accion_ejecutar" value="Borrar" />
@%where:tabla|Bancos;no_results|1;order|Bancos.nombre asc;%@
<table class="full">
<tr><td class="check"><input type="checkbox" name="bancos[]" value="@%db:Bancos.id_banco%@" /></td>
<td class="etiqueta">Nom Banc:</td>
<td><a href="?seccion=bo_bancos_empresa&id_banco=@%db:Bancos.id_banco%@">@%db:Bancos.nombre%@</a></td>
<td class="etiqueta">Adreça:</td>
<td>@%db:Bancos.direccion%@</td>
</tr>
<tr>
<td></td>
<td class="etiqueta">Població:</td>
<td>@%db:Bancos.poblacion%@</td>
<td class="etiqueta">Persona de contacte:</td>
<td>@%db:Bancos.persona_contacto%@</td>
</tr>
<tr>
<td></td>
<td class="etiqueta">Telèfon:</td>
<td colspan="3">@%db:Bancos.telefono%@</td>
 </tr>
</table>
@%end-where:%@







</form>
