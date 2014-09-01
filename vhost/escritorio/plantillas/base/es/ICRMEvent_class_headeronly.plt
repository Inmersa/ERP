@%where:nodb|class_dbItemMultiEntity_iface;nombre|FichaEvento;%@
@%if:esta_vacio;formvar_name;%@
  @%set:formvar_name=incidencias;%@
@%end-if:%@

<fieldset class="fsficha" id="OpcionesIncidencia">
<legend>&gt;<a href="?seccion=rfq&id=@%db:id;%@" />RFQ-@%db:id;%@</a></legend>

<table class="full">
<thead>
<tr>
<!-- img src="img/cuadro2.gif" width="15" height="10" -->
<td >Tipo</td>
<td >Prioridad</td>
<td >Fecha de Entrada</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td >Fecha inicio</td>
<td >Fecha Aproximada Finalización</td>
@%end-if:%@
@%if:esta_vacio;fecha_cierre;%@
@%else:%@
<td >Fecha Fin</td>
@%end-if:%@
</tr>
</thead>
<tbody>
<tr> 
<td >@%db:Tipo.nombre;%@</td>
<td >@%db:Prioridad.nombre%@</td>
<td >@%db:colocar_fecha_hora{fecha};%@</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td >@%db:colocar_fecha_hora{fecha_inicio};%@</td>
<td >@%db:colocar_fecha_hora{fecha_estimada};%@</td>
@%end-if:%@
@%if:esta_vacio;fecha_cierre;%@
@%else:%@
<td >@%db:colocar_fecha_hora{fecha_cierre};%@</td>
@%end-if:%@
</tr>
</table>

<table class="full">
<thead>
<tr>
 <td >Usuario implicado</td>
@%if:AllowedAction;RFQs_id_usuario_gestor;new;%@
 <td >Usuario Gestor</td>
@%end-if:%@
 <td >Usuario de Apertura</td>
</tr>
</thead>

<tbody>
<tr>
<td >@%db:Implicado.nombre%@ @%db:Implicado.apellidos%@</td>

<!-- Si se puede acceder al campo.. -->
@%if:AllowedAction;RFQs_id_usuario_gestor;new;%@
<td> @%db:Gestor.nombre%@ @%db:Gestor.apellidos%@ @%db:Gestor.cargo%@ @%db:Departamentos.nombre%@ </td>
@%end-if:%@

<td >@%db:Apertura.nombre%@ @%db:Apertura.apellidos%@ @%db:Apertura.cargo;%@</td>
</tr>
</table>

<div class="encabezado">Nota de apertura pública</div>
<div class="notaapertura">@%db:reemplazar_salto{nota_apertura};%@</div>

</fieldset>

@%end-where:%@
