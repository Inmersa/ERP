

<table width="644" border="0" cellspacing="0" cellpadding="0">
<thead>
 <tr>
 <td ></td>
 <td >Référence</td>
 <td >Usager</td>
 <td >Début de période</td>
 <td >Date approximative terminer</td>
 <td >État</td>
 </tr>
</thead>
<tbody>
 <form name="borrar_incidencias" action="?@%env:QUERY_STRING%@" method="post">
@%where:tabla|Pedidos_Incidencias_CRM;nolink|1;where|id_pedido = $id_documento;%@
<!-- @%db:Pedidos_Incidencias_CRM.id_incidencia;%@ @%set:id_incidencia=Pedidos_Incidencias_CRM.id_incidencia;%@ -->
@%where:db|crm;tabla|Incidencias;where|id_incidencia = $id_incidencia;%@ 
<!-- AND Incidencias.id_prioridad=Margenes_tiempo.id_prioridad; -->
 <tr>
 <td bgcolor="#DBE0E3" height="22" class="etiqueta"> </td>
 <td class="etiqueta">
 <a href="@%get:LinkCRM;%@/?seccion=incidencia&id=@%db:Incidencias.id_incidencia%@"
 >INC-@%db:Incidencias.id_incidencia%@ @%db:Incidencias.nota_apertura%@</a></td>
 <td align="center" class="texto">
 <!-- @%db:Incidencias.id_usuario_gestor;%@ @%set:id_gestor=Incidencias.id_usuario_gestor%@ -->
 @%where:db|crm;tabla|Usuarios;where|id_usuario = $id_gestor;nolink|1;%@ @%db:Usuarios.nombre%@ @%db:Usuarios.apellidos%@ @%end-where:%@ </td>
 <td align="center" class="texto">@%db:colocar_fecha{Incidencias.fecha}%@</td>
 <!-- @%wdb:Margenes_tiempo.horas_estimadas%@ -->
 <td align="center"> <!-- @%wdb:DATE_ADD(Incidencias.fecha,INTERVAL Margenes_tiempo.horas_estimadas HOUR) as 'fecha_estimada'%@ -->
 </td>
 <td align="center"><!-- @%db:Incidencias.estado%@ -->
 <img src="imag/@%func:luz_estado_incidencia;Incidencias.estado;triangulo.png;verde.jpg%@">
 </td>
 </tr>
 @%end-where:%@

 @%end-where:%@

</tbody>
</table>
</form>

 
