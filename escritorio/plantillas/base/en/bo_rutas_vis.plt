<table width="647" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#FFFFFF" height="30">
@%plt:botonera%@
</td>
 </tr>
 <tr> <td height="22" bgcolor="#FFFFFF"> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <form name="bo_rutas" action="">
 <input type="hidden" name="accion_ejecutar" value="">
 <tr> <td height="22" align="right" bgcolor="#CCD2D7"> <table width="150" border="0" cellspacing="0" cellpadding="0">
 <tr> <td align="left">
<a href="" class="accesos">Add</a>
</td>
<td width="20" align="center"></td>
 <td align="center">
<a href="#" onClick="return onHrefClick('bo_rutas','accion_ejecutar', 'Generar');" class="accesos">Create Day Work</a>
</td>
<td ></td>
 <td width="146" align="right">
<a href="#" onClick="return onHrefClick('bo_rutas','accion_ejecutar', 'Borrar');" class="accesos">Delete selected</a>
</td>
 <td width="4"></td>
 </tr>
 </table>
 </td>
 </tr>
 <tr> <td height="3"> </td>
 </tr>
 <tr> <td> <table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr> <td bgcolor="#DBE0E3" width="1" class="etiqueta" align="center"></td>
 
 <td width="1"></td>
 <td width="24" bgcolor="#DBE0E3"></td>
 
 <td bgcolor="#DBE0E3" class="etiqueta" width="288">Route</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="264">Frequency / Days</td>
 <td width="1"></td>

 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="264">Last date </td>
 <td width="1"></td>

 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="264">N� Clients</td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="257" align="center">Agent </td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="176">Next date</td>
 <td width="1"></td>
 </tr>
 @%where:tabla|Rutas;nombre|busc;no_results|1;%@
 <!-- aqui viene el registro @%set:ultima_fecha_recorrido=--;%@ @%set:proxima_fecha_recorrido=--;%@ @%db:set:numero_clientes=0%@
 @%where:tabla|Recorridos;nombre|fechas;where|Recorridos.fecha < NOW();group|Recorridos.id_ruta;%@
 @%db:MAX(Recorridos.fecha) as 'ultima_fecha' ;%@
 @%set:ultima_fecha_recorrido=ultima_fecha;%@
 @%end-where:%@

 @%where:tabla|Recorridos;nombre|fechas;where|Recorridos.fecha > NOW();group|Recorridos.id_ruta;%@
 @%db:MIN(Recorridos.fecha) as 'proxima_fecha' ;%@
 @%set:proxima_fecha_recorrido=proxima_fecha;%@
 @%end-where:%@

@%where:tabla|Rutas_clientes;nombre|clientes;group|Rutas_clientes.id_ruta;%@
@%db:COUNT(Rutas_clientes.id_cliente) as 'numero_cliente';%@
@%set:numero_clientes=numero_cliente;%@
@%end-where:%@

 -->
 <tr> <td bgcolor="#DBE0E3" width="1"></td>
 <td width="1"></td>
 <td bgcolor="#DBE0E3" valign="top" height="22" > <input type="checkbox" name="bo_rutas_borrar[@%db:Rutas.id_ruta%@]" value="1">
 </td>
 <td class="texto" ><a href="?seccion=modif_rutas&id_ruta=@%db:Rutas.id_ruta;%@" class="accesos">@%db:Rutas.nombre;%@</a></td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="center" >@%db:Rutas.d_frecuencia;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" >@%get:ultima_fecha_recorrido;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" align="right" >@%get:numero_clientes;%@
 </td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" >@%db:Agentes.nombre;%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
 <td class="texto" >@%get:proxima_fecha_recorrido%@</td>
 <td bgcolor="#DBE0E3" width="1"></td>
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
 <tr> <td bgcolor="#FFFFFF" height="30"> @%plt:botonera%@ </td>
 </tr>
 <tr>
 <td bgcolor="#FFFFFF" height="3"></td>
 </tr>
 </table>

