@%plt:botonera%@

<table class="full">
<tr>
<td></td>
<td class="etiqueta">Nome</td>
<td class="etiqueta">Descri��o</td>
<td class="etiqueta">Respons�vel</td>
</tr>
<form name="modif_certificados" action="" method="post">
<input type="hidden" name="estado" value="3" />

 @%where:tabla|Certificados;nombre|busc;%@

<tr><td class="check"><input type="checkbox" name="registro_borrar[@%db:Certificados.id_certificado;%@]"value="1" /></td>
<td class="etiqueta"> <a href="?seccion=modif_certificados&id_certificado=@%db:Certificados.id_certificado;%@">@%db:Certificados.nombre;%@</a></td>
<td>@%db:Certificados.descripcion;%@</td>
<td>@%db:Certificados.responsable;%@</td>
</tr>


@%end-where:%@


</form>
 </table>
@%plt:botonera%@

<div class="enviar"><a href="javascript:document.forms['modif_certificados'].submit();">Eliminar Itens Seleccionados</a></div>