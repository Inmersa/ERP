
<!--botonera de paguina primera--><br>
<table width="498" border="0" cellspacing="0" cellpadding="0">
 <tr> 
 @%if:anterior;%@
 <td> <a href="?pag=@%func:pg_ant;%@" onclick="mandar_reserva('?pag=@%func:pg_ant%@&id_noticia=@%env:id_noticia%@');return false;"
 class="maslink">&lt;&lt; Prev</a> 
 @%else:%@
 <td>
 @%end-if:%@
 @%where:nodb|nodbbotonera;%@
 @%if:paginar;%@
 <a href="?pag=@%db:link_page%@" onclick="mandar_reserva('?pag=@%db:link_page%@&id_noticia=@%env:id_noticia%@');return false;"
 class="texto_link">@%db:disp_page%@</a> 
 @%else:%@
<span class="maslink">@%db:disp_page%@</span> 
@%end-if:%@
 @%end-where:%@

 @%if:siguiente%@
 <a href="?pag=@%func:pg_sig%@" onclick="mandar_reserva('?pag=@%func:pg_sig%@&id_noticia=@%env:id_noticia%@');return false;"
 class="maslink">next &gt; &gt;</a>
 @%end-if:%@

 </td>
 </tr>
</table>

