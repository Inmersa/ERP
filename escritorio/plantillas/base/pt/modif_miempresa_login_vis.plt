@%where:tabla|Empresas;where|Empresas.id_empresa = $id_empresa;%@

<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="30">
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#EBECED" height="22" align="left" colspan="2" class="etiqueta"> Iniciar Sessão</td>
 </tr>
 <!-- @%db:Empresas.mask%@ @%set:emp_mask=Empresas.mask%@ -->
@%where:db|conf;tabla|Users;where|Users.av_group & $emp_mask;%@
 <tr> <td class="texto" width="291"> @%db:Users.login%@</td>
 </tr>
@%end-where:%@

<tr>
 </tr>
 </table>
 </td>
 </tr>
 </table>

