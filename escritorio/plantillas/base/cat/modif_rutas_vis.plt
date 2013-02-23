

 <table width="647" border="0" cellspacing="0" cellpadding="0">Raó social
 <tr> <td bgcolor="#FFFFFF" height="10"></td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="10"> <form name="modif_rutas" action="" method="post">
<input type="hidden" name="registro[id_ruta]" value="@%db:Rutas.id_ruta%@">
 <table width="644" border="0" cellpadding="0" cellspacing="0">
 <tr bgcolor="#CCD2D7"> <td colspan="6" height="22"></td>
 </tr>
 <tr> <td colspan="6" height="1"></td>
 </tr>
<tr bgcolor="#EBECED"> </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td colspan="4" height="1" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" width="150" height="22" class="etiqueta">Nom ruta:</td>
 <td width="215" class="texto"> <input type="text" name="registro[nombre]" class="insertext" size="25" value="@%db:Rutas.nombre%@">
 </td>
 <td bgcolor="#EBECED" align="right" width="125" class="etiqueta">Grup de rutes:</td>
 <td width="154" class="insertext"> <!-- @%set:_selected_value=Rutas.id_grupo_ruta%@ @%db:Rutas.id_grupo_ruta%@ -->
 <select name="registro[id_grupo_ruta]">
 @%where:tabla|Grupo_rutas;nolink|1;%@
 <option value="@%db:Grupo_rutas.id_grupo_ruta%@"
@%db:selected_value{Grupo_rutas.id_grupo_ruta}%@
>@%db:Grupo_rutas.nombre%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" height="22" class="etiqueta" width="150">Agent:</td>
 <td colspan="3"> <!-- @%set:_selected_value=Rutas.id_agente%@ @%db:Rutas.id_agente%@ -->
 <select name="registro[id_agente]" class="insertext">
 @%where:tabla|Agentes;nolink|1;%@
 <option value="@%db:Agentes.id_agente%@"
@%db:selected_value{Agentes.id_agente}%@
>@%db:Agentes.nombre%@</option>
 @%end-where:%@

 </select>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td bgcolor="#EBECED" align="right" height="22" class="etiqueta" width="150">Descripció:</td>
 <td colspan="3"> <textarea name="registro[descripcion]" cols="70" class="insertext">@%db:Rutas.descripcion%@</textarea>
 </td>
 </tr>
 <tr> <td colspan="4" bgcolor="#CCD2D7" height="1"></td>
 </tr>
 <tr> <td height="10" colspan="4"></td>
 </tr>
 <tr> <td height="1" colspan="4" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" class="etiqueta" align="right" width="150">Duració visita (minuts) (Minutes): </td>
 <td height="1" width="215"> <input type="text" name="registro[m_visita]" value="@%db:Rutas.m_visita%@" class="texto">
 </td>
 <td height="1" bgcolor="#EBECED" align="right" class="etiqueta" width="125">Duració trasllat (minuts) (Minutes):</td>
 <td height="1" width="154"> <input type="text" name="registro[m_traslado]" value="@%db:Rutas.m_traslado%@" class="insertext">
 </td>
 </tr>
 <tr> <td height="1" colspan="4" bgcolor="#CCD2D7"></td>
 </tr>
 <tr> <td height="22" bgcolor="#EBECED" class="etiqueta" align="right" width="150">Freqüència / dies (Dies) :</td>
 <td height="1" width="215"> <input type="text" name="registro[d_frecuencia]" value="@%db:Rutas.d_frecuencia;%@" class="texto">
 </td>
 <td height="1" bgcolor="#EBECED" class="etiqueta" align="right" width="125">Duració ruta (hores) (Horas):</td>
 <td height="1" width="154"> <input type="text" name="registro[h_duracion]" value="@%db:Rutas.h_duracion%@" class="texto">
 </td>
 </tr>
 <tr> <td height="1" colspan="4" bgcolor="#CCD2D7"></td>
 </tr>
 </table>
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22"></td>
 </tr>
 <tr> <td height="22" bgcolor="#CCD2D7" align="center">
 <input type="hidden" name="accion_ejecutar" value="Guardar">
 <a href="javascript:document.forms['modif_rutas'].submit();" class="accesos">Afegir</a></td>
 </tr>
 </table>
 </form>
 </td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="10"></td>
 </tr>
 <tr> <td bgcolor="#91CC00" height="20" class="titocho">>Llistat de clients en ruta</td>
 </tr>
</table>
<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td height="22" bgcolor="#FFFFFF">
 <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="clientes_ruta" action="">
 <input type="hidden" name="accion_ejecutar" value="">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table border="0" cellspacing="0" cellpadding="0">
 <tr> 
<td width="146" align="right"></td>
<!-- onClick="return onHrefClick('clientes_ruta', 'accion_ejecutar', 'Anyadir_cliente');" -->
<td width="4"></td>
 <td width="200" align="center"></td>
 <td width="4"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
<tr> <td bgcolor="#DBE0E3" width="1" class="etiqueta" align="center"></td>
 <td width="20" bgcolor="#DBE0E3"></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" width="70" class="etiqueta">Codi</td>

 <td bgcolor="#DBE0E3" class="etiqueta" width="170">Client<span class="texto"> | Raz&oacute;n social</span></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="170">Adreça</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">Mig de contacte</td>
 <td class="etiqueta" align="center" width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center">Ordre</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 </tr>
 <!-- aqui viene el registro -->
 @%where:tabla|Clientes;no_results|1;order|Clientes.razon_social, Clientes.nombre, Clientes.apellidos;%@
 <tr> <td></td>
 <td height="2"></td>
 <td></td>
 <td height="2"></td>
 <td colspan="8"></td>
 </tr>
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td bgcolor="#91CC00" valign="top"> </td>
 <td></td>
 <td class="texto" align="center">@%db:Clientes.id_cliente;%@<br>
 <br>
 <br>
 </td>
 <td class="texto"><a href="?seccion=modif_clientes&id_cliente=@%db:Clientes.id_cliente;%@" class="accesos">@%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@</a><br>
 @%db:Clientes.razon_social;%@<br>
 @%db:Provincias.nombre;%@ - @%db:Clientes.poblacion;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto">@%db:Clientes.cargo_persona_contacto;%@<br>
 <a href="mailto:@%db:Clientes.email;%@" class="accesos">@%db:Clientes.email;%@</a><br>
 @%db:Clientes.telefono1;%@</td>
 <td bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Clientes.prefijo_cif;%@ - @%db:Clientes.cif;%@<br>
 <br>
 <br>
 </td>
 <td class="texto" align="center" bgcolor="#DBE0E3"></td>
 <td class="texto" align="center">@%db:Tipo_cliente.nombre;%@<br>
 <br>
 <br>
 </td>
 <td bgcolor="#DBE0E3"></td>
 </tr>
 <tr> <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3" ></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 <td height="3"></td>
 </tr>

 <tr> <td height="1" colspan="12" bgcolor="#DBE0E3"></td>
 </tr>
 @%end-where:%@

 </table>
 </td>
 </tr>
 </form>
 </table>
</td>
 </tr>
 <tr> <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
</table>




