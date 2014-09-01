

<table width="644" border="0" cellspacing="0" cellpadding="0">
 <tr>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center"></td>
 <td bgcolor="#DBE0E3" width="120" class="etiqueta">Referencia</td>
 <td bgcolor="#DBE0E3" class="etiqueta" >Usuario Gestor</td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">Fecha de alta</td>
 <td bgcolor="#DBE0E3" class="etiqueta" align="center" width="120">Fecha Aprox. Finalización</td>
 <td bgcolor="#DBE0E3" class="etiqueta" width="50" align="center">Estado</td>
 </tr>
 <tr>
 </tr>
 <form name="borrar_incidencias" action="?@%env:QUERY_STRING%@" method="post">
@%where:tabla|Facturas_Incidencias_CRM;nolink|1;where|id_factura = $id_documento;%@
<!-- @%db:Facturas_Incidencias_CRM.id_incidencia;%@ @%set:id_incidencia=Facturas_Incidencias_CRM.id_incidencia;%@ -->
@%where:db|db_crm;tabla|Incidencias;where|id_incidencia = $id_incidencia;%@ 
<!-- AND Incidencias.id_prioridad=Margenes_tiempo.id_prioridad; -->
 <tr>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta"> </td>
 <td class="etiqueta">
 <a href="@%get:LinkCRM;%@/?seccion=incidencia&id=@%db:Incidencias.id_incidencia%@"
 >INC-@%db:Incidencias.id_incidencia%@ @%db:Incidencias.nota_apertura%@</a></td>
 <td align="center" class="texto">
 <!-- @%db:Incidencias.id_usuario_gestor;%@ @%set:id_gestor=Incidencias.id_usuario_gestor%@ -->
 @%where:db|db_crm;tabla|Usuarios;where|id_usuario = $id_gestor;nolink|1;%@ @%db:Usuarios.nombre%@ @%db:Usuarios.apellidos%@ @%end-where:%@ </td>
 <td align="center" class="texto">@%db:colocar_fecha{Incidencias.fecha}%@</td>
 <!-- @%wdb:Margenes_tiempo.horas_estimadas%@ -->
 <td align="center" class="texto"> <!-- @%wdb:DATE_ADD(Incidencias.fecha,INTERVAL Margenes_tiempo.horas_estimadas HOUR) as 'fecha_estimada'%@ -->
 </td>
 <td align="center"><!-- @%db:Incidencias.estado%@ -->
 <img src="imag/@%func:luz_estado_incidencia;Incidencias.estado;triangulo.png;verde.jpg%@">
 </td>
 </tr>
 @%end-where:%@

 @%end-where:%@

</form></table>

 
