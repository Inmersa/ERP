
 <form method="post" action="#" name="buscadorgeneral"><tr>

 <input type="hidden" name="nom_bus" value="incidencias_abiertas" />
 Texto<input type="text" name="nombre" size="6" value="@%get:st_nombre;%@" />
 Estado :
 <select name="estado" >
 <option value="">Não Existem Itens Seleccionados</option>
 <option value="0"
 @%if:equals;st_estado;0;%@
 selected="selected"
 @%end-if:%@
 >Pendente</option>
 <option value="1"
 @%if:equals;st_estado;1;%@
 selected="selected"
 @%end-if:%@
 >Abertas</option>
 <option value="2"
 @%if:equals;st_estado;2;%@
 selected="selected"
 @%end-if:%@
 >Encerradas</option>

 </select>

 Envolvido <input type="text" name="implicado" size="20" value="@%get:st_implicado;%@" />
 <!-- @%set:_selected_value="st_id_tipo_incidencia;%@" -->
 <select name="id_tipo_incidencia">
 <option value="">Não Existem Itens Seleccionados</option>
@%where:db|crm;tabla|Tipo_incidencia;nolink|1;where|Tipo_incidencia.tipo = 0;order|Tipo_incidencia.nombre;%@
 <option value="@%db:Tipo_incidencia.id_tipo_incidencia;%@"
 @%db:selected_value{Tipo_incidencia.id_tipo_incidencia};%@
>@%db:Tipo_incidencia.nombre;%@</option>
<!--@%db:Departamentos.id_coordinador%@-->
 @%end-where:%@

 </select>
 de: <input type="text" name="fecha_inicio" size="12" maxlength="10" 
 @%if:esta_vacio;st_fecha_inicio;%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st_fecha_inicio;%@"
 @%end-if:%@
 />
 G: <input type="text" name="fecha_fin" size="12" maxlength="10" 
 @%if:esta_vacio;st_fecha_fin;%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st_fecha_fin;%@"
 @%end-if:%@
 />

 <a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="p" >Pesquisar</a>
 <select name="hp">
@%where:nodb|nodb_hits_page;%@
<option value="@%db:value;%@"
@%if:equals;st_hp;value;%@
selected="selected"
@%end-if:%@
>@%db:name;%@</option>
@%end-where:%@

</select>
</form>

