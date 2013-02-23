@%where:nodb|class_dbItemMultiEntity_iface;nombre|FichaEvento;%@
@%if:esta_vacio;formvar_name;%@
  @%set:formvar_name=incidencias;%@
@%end-if:%@

<fieldset class="fsficha" id="OpcionesIncidencia">
<legend>&gt;
@%if:esta_vacio;id;%@
RFQ-
@%else:%@
<a href="@%get:LinkCRM;%@/?seccion=rfq&id=@%db:id;%@" >RFQ-@%db:id;%@</a>
@%end-if:%@
</legend>

<table class="full">
<thead>
<tr>
<!-- img src="img/cuadro2.gif" width="15" height="10" -->
<td >Tipo</td>
<td >Prioridade</td>
<td >Data de Entrada</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td >Data de Ínicio</td>
<td >Data Aproximada de Conclusão</td>
@%end-if:%@
@%if:esta_vacio;fecha_cierre;%@
@%else:%@
<td >Data Final</td>
@%end-if:%@
</tr>
</thead>
<tbody>
<tr> 
<td >
<!-- @%set:_selected_value=Tipo.id;%@ @%set:tipo=Tipo.tipo;value|var;%@ 
@%if:esta_vacio;tipo;%@
	@%set:tipo=crm_tipo_nuevo_evento;value|var;%@
@%end-if:%@
-->
@%if:esta_vacio;estado;id;%@
	<select name="@%get:formvar_name;%@[id_tipo_incidencia]" >
	@%where:db|crm;tabla|Tipo_incidencia;where|tipo = $tipo;nolink|1;%@
	<option value="@%db:Tipo_incidencia.id_tipo_incidencia;%@" 
		@%db:selected_value{Tipo_incidencia.id_tipo_incidencia};%@ 
		>@%db:Tipo_incidencia.nombre;%@</option>
	@%end-where:%@

	</select>
@%else:%@
	@%if:esta_vacio;estado;%@
		@%if:AllowedAction;RFQ_id_tipo;edit;%@
		<select name="@%get:formvar_name;%@[id_tipo_incidencia]" >
		@%where:db|crm;tabla|Tipo_incidencia;where|tipo = $tipo;nolink|1;%@
		<option value="@%db:Tipo_incidencia.id_tipo_incidencia;%@" 
			@%db:selected_value{Tipo_incidencia.id_tipo_incidencia};%@ 
			>@%db:Tipo_incidencia.nombre;%@</option>
		@%end-where:%@

		</select>
		@%else:%@
		@%db:Tipo.nombre;%@
		@%end-if:%@
	@%else:%@
		@%db:Tipo.nombre;%@
	@%end-if:%@
@%end-if:%@
</td>
<td >
@%if:esta_vacio;fecha_cierre;;%@
	<!-- @%set:_selected_value=id_prioridad;value|var;%@ -->
	@%if:AllowedAction;RFQ;edit;%@
		<select name="@%get:formvar_name;%@[id_prioridad]">
		@%where:db|crm;tabla|Prioridades;nolink|1;%@
			<option value="@%db:Prioridades.id_prioridad%@"
			@%db:selected_value{Prioridades.id_prioridad}%@
			>@%db:Prioridades.nombre;%@</option>
		@%end-where:%@

		</select>
	@%else:%@
		@%if:esta_vacio;estado;id;%@
		<select name="@%get:formvar_name;%@[id_prioridad]">
		@%where:db|crm;tabla|Prioridades;nolink|1;%@
			<option value="@%db:Prioridades.id_prioridad%@"
			@%db:selected_value{Prioridades.id_prioridad}%@
			>@%db:Prioridades.nombre;%@</option>
		@%end-where:%@

		</select>
		@%else:%@
		@%db:Prioridades.nombre%@
		@%end-if:%@
	@%end-if:@
@%else:%@
	@%db:Prioridades.nombre%@
@%end-if:%@
</td>
<td >@%db:colocar_fecha{fecha};%@</td>
@%if:esta_vacio;estado;%@
@%else:%@
<td >@%db:colocar_fecha{fecha_inicio};%@</td>
<td >@%db:colocar_fecha{fecha_estimada};%@</td>
@%end-if:%@
@%if:esta_vacio;fecha_cierre;%@
@%else:%@
<td >@%db:colocar_fecha{fecha_cierre};%@</td>
@%end-if:%@
</tr>
</table>

<table class="full">
<thead>
<tr>
 <td >Utilizador Envolvido</td>
@%if:AllowedAction;RFQ_id_usuario_gestor;new;%@
 <td >Responsável Actual</td>
@%end-if:%@
 <td >Utilizador de Abertura</td>
</tr>
</thead>

<tbody>
<tr>
<td >@%db:Implicado.nombre%@ @%db:Implicado.apellidos%@</td>

<!-- Si se puede acceder al campo.. -->
@%if:AllowedAction;RFQ_id_usuario_gestor;new;%@
<td> @%db:Gestor.nombre%@ @%db:Gestor.apellidos%@ @%db:Gestor.cargo%@ @%db:Departamentos.nombre%@ </td>
@%end-if:%@

<td >@%db:Apertura.nombre%@ @%db:Apertura.apellidos%@ @%db:Apertura.cargo;%@</td>
</tr>
</table>

<div class="encabezado">Nota de Abertura Pública</div>
<div class="notaapertura">
@%if:esta_vacio;estado;id;%@
<textarea name="@%get:formvar_name;%@[nota_apertura]" rows="5" cols="80">@%db:nota_apertura;%@</textarea>
@%else:%@
@%db:reemplazar_salto{nota_apertura};%@
@%end-if:%@
</div>

</fieldset>

@%end-where:%@
