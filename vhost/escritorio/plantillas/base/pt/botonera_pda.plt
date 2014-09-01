<!--botonera de paguina primera-->
<table width="644" border="0" cellspacing="0" cellpadding="0" class="texto">
 <tr> <td width="6"></td>
 <td >

@%if:anterior%@
<a href="?pag=@%func:pg_ant%@" class="accesos">Anterior</a> 
@%else:%@ 
@%end-if:%@ 

@%where:nodb|nodbbotonera;%@
@%if:paginar%@
<!-- a href="?pag=@%db:link_page%@" class="accesos">@%db:disp_page%@</a --> 
@%else:%@
 <!-- font color="#999999"><b>@%db:disp_page%@</b></font -->
@%end-if:%@
@%end-where:%@ 
@%if:siguiente%@
 <a href="?pag=@%func:pg_sig%@" class="accesos">Seguinte</a>
@%end-if:%@
 </td>
 </tr>
</table>
