<html>
<head>
<title>{{label_clientesruta}}</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="estilos.css" type="text/css">
</head>

<body bgcolor="#FFFFFF" text="#000000">
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr> <td class="titocho" align="right">{{label_inmersaempresa}}: {{fld_cif}}</td>
<td class="titocho" align="right"><a href="?logout=1"
class="accesos">{{acc_logout}}</a>
 </tr>
<tr> <td class="accesos" align="right">
</td>
 </tr>
</table>
<table width="200" border="0" cellspacing="0" cellpadding="0">
<tr> 
<form method="post" action="?seccion=pda_cliente" name="clienteid">
 <td class="acceso_directo" align="left">{{label_pedidoidcliente}}:</td>
 <td><input type="text" border="cccccc" name="id_cliente" class="insertext" size="5"><input type="submit" value="{{acc_enviar}}">
 </td>
</form>
 </tr>
<tr> 
<form method="post" action="?seccion=pda_clientes_ruta" name="pda">
<input type="hidden" name="nom_bus" value="recorridos_search">
 <td class="acceso_directo" align="left">{{label_fecharuta}} :</td>
 <td><input type="text" border="cccccc" name="fecha" class="insertext" size="10"
 value="@%get:st_fecha;%@"><input type="submit" value="{{acc_enviar}}"></td>
</form>
 </tr>
<tr>
<td height="10">
<!-- @%wplt:botonera%@ -->
</td>
</tr>
</table>

@%where:tabla|Recorridos;nombre|busc;no_results|1;order|h_inicio asc;limit|1;%@
<!-- @%db:Recorridos.h_inicio%@ @%db:Recorridos.h_fin%@
@%db:Recorridos.id_recorrido%@ @%set:id_recorrido_act=Recorridos.id_recorrido;tipo|SECCION;%@
@%set:fecha_recorrido=Recorridos.fecha;%@
-->
<table width="200" border="0" cellspacing="0" cellpadding="0">
 <td class="accesos2" align="left">[@%db:Rutas.nombre%@] @%db:colocar_fecha{Recorridos.fecha}%@
@%if:esta_vacio;Recorridos.h_inicio;Recorridos.h_fin;%@
<a href="?id_recorrido=@%db:Recorridos.id_recorrido%@&iniciar=1" class="accesos">{{acc_iniciarruta}}</a>
@%set:estado_noiniciado=1;%@
@%else:%@
@%end-if:%@
@%if:esta_vacio;Recorridos.h_fin;estado_noiniciado;%@
<a href="?seccion=pda_cierre_ruta&id_recorrido=@%get:id_recorrido_act;%@" class="accesos">{{fld_cierrederuta}}</a>
@%set:estado_iniciado=1;%@
@%else:%@
@%end-if:%@
@%if:esta_vacio;estado_noiniciado;estado_iniciado;%@
Ruta Cerrada
@%set:estado_cerrado=1;%@
@%else:%@
@%end-if:%@

</td>
 <tr>
<td height="10"></td>
</tr>
 </table>

 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
<td class="titul1" align="left">{{label_clientesenruta}}:</td>
</tr>
<tr>
<td height="10"></td>
</tr>
@%where:tabla|Citas;nombre|citas;order|Citas.h_inicio asc;%@
<!-- @%db:Citas.id_cita;%@ @%db:Citas.h_fin_sys;%@-->
@%if:esta_vacio;Citas.h_fin_sys;%@
@%set:cita_abierta=0%@
@%else:%@
@%set:cita_abierta=1%@
@%end-if:%@
<tr>
 <td class="acceso_directo" align="left">
 @%if:esta_vacio;estado_noiniciado;estado_cerrado;cita_abierta;%@
 <a href="?seccion=pda_cliente&id_cita=@%db:Citas.id_cita%@" class="accesos">
 @%db:Clientes.razon_social%@</a>
 @%else:%@
 @%db:Clientes.razon_social%@
 @%end-if:%@
 </td>
 <td class="acceso_directo" align="left">
 @%if:esta_vacio;estado_noiniciado;estado_cerrado;cita_abierta;%@
 <a href="?seccion=pda_cliente&id_cita=@%db:Citas.id_cita%@" class="accesos">
 @%db:Clientes.id_cliente%@</a>
 @%else:%@
 @%db:Clientes.id_cliente%@
 @%end-if:%@
 </td>
</tr>
<tr>
 <td class="acceso_directo" align="left">
 @%if:esta_vacio;estado_noiniciado;estado_cerrado;cita_abierta;%@
 <a href="?seccion=pda_cliente&id_cita=@%db:Citas.id_cita%@" class="accesos">
 @%db:Clientes.direccion_facturacion%@</a>
 @%else:%@
 @%db:Clientes.direccion_facturacion%@
 @%end-if:%@
 </td>
 <td class="acceso_directo" align="left">
 @%if:esta_vacio;estado_noiniciado;estado_cerrado;cita_abierta;%@
 <a href="?seccion=pda_cliente&id_cita=@%db:Citas.id_cita%@" class="accesos">
 @%db:Clientes.poblacion%@</a>
 @%else:%@
 @%db:Clientes.poblacion%@
 @%end-if:%@
 </td>
</tr>
<tr>
<td height="6"></td>
</tr>
@%end-where:%@

<tr> <td class="accesos" align="right">
</td>
 </tr>
 </table>
 <table width="200" border="0" cellspacing="0" cellpadding="0">
 <tr>
<td class="titul1" align="left" colspan="2">{{label_otrosrecorridos}}:</td>
</tr>
<tr>
<td height="10" colspan="2"></td>
</tr>
@%if:esta_vacio;fecha_recorrido;%@
@%else:%@
<form method="post" action="?seccion=pda_clientes_ruta" name="pda">
<input type="hidden" name="nom_bus" value="recorridos_search">
@%where:tabla|Recorridos;nombre|otrosrec;no_results|1;order|h_inicio asc;where|Recorridos.fecha = '$fecha_recorrido' AND Recorridos.id_agente = $id_agente_pda AND Recorridos.id_recorrido != $id_recorrido_act;nolink|1;%@
<tr><td rowspan="2" class="acceso_directo" width="5"><input type="radio" value="@%db:Recorridos.id_recorrido;%@"
name="id_recorrido" class="insertext"></td> 
<td class="acceso_directo" align="left">[@%db:Rutas.nombre%@] 
@%db:colocar_fecha{Recorridos.fecha}%@</td></tr>
<tr><td class="acceso_directo" align="left">
@%if:esta_vacio;Recorridos.h_inicio;%@
@%else:%@
[ Hi:@%db:Recorridos.h_inicio;%@ ]
@%end-if:%@
@%if:esta_vacio;Recorridos.h_fin;%@
@%else:%@
Hf:@%db:Recorridos.h_fin;%@
@%end-if:%@
</td></tr>
@%end-where:%@

<tr><td height="11" class="acceso_directo" colspan="2"></td></tr>
<tr><td class="acceso_directo" colspan="2"><input type="submit" value="{{acc_ver}}"></td></tr>
</form>
@%end-if:%@
<tr> <td class="accesos" align="right">
</td>
 </tr>
 </table>
@%end-where:%@

</body>
</html>

