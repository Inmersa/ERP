<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30"> 
@%plt:botonera%@ 
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF">
<form action="?seccion=modif_clientes" name="importar_recomendador" method="post">
<input type="hidden" name="accion_ejecutar" value="Modificar">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td height="22" bgcolor="#CCD2D7"></td>
 </tr>
 <tr>
 <td>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td>
 <table width="643" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#CCD2D7" width="1"></td>
 <!-- @%set:_inm_count_times=2;%@ -->
@%where:tabla|Clientes;order|Clientes.nombre,Clientes.apellidos;nombre|busc;no_results|1;%@
 <td class="texto" height="22">
 <!--@%db:Clientes.id_cliente%@-->
<input type="radio" name="id_recomendador" value="@%db:Clientes.id_cliente%@"> @%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@
</td>
 @%if:contador_inm%@
 </tr>
 <tr bgcolor="#CCD2D7"> <td colspan="7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#CCD2D7" width="1"></td>
 @%else:%@
 <td bgcolor="#CCD2D7" width="1"></td>
 @%end-if:%@
 
 @%end-where:%@
 
</table>

</td>
 <td width="1" bgcolor="#CCD2D7"></td>
 </tr>
</table>
 </td>
 </tr>
 <tr>
 <td height="22" bgcolor="#CCD2D7" align="center"> <input type="hidden" name="Importar" value="Importar">
 <a href="" onclick="document.forms['importar_recomendador'].submit();return false;" class="accesos">Importar </a></td>
 </tr>
 </table>
 </form>
 </td>
 </tr>
 <tr> <td height="30"> 
@%plt:botonera%@
 </td>
 </tr>
</table>

