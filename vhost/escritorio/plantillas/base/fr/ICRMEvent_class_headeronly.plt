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
<td >Type</td>
<td >Priorité</td>
<td >Date d'entrée</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td >Debut de periode</td>
<td >Date approximative terminer</td>
@%end-if:%@
@%if:esta_vacio;fecha_cierre;%@
@%else:%@
<td >Date final</td>
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
 <td >Usager impliqué</td>
@%if:AllowedAction;RFQs_id_usuario_gestor;new;%@
 <td >Usager gestionnaire</td>
@%end-if:%@
 <td >Usager ouverture</td>
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

<div class="encabezado">Note de ouverture publiqe</div>
<div class="notaapertura">@%db:reemplazar_salto{nota_apertura};%@</div>

</fieldset>

@%end-where:%@
