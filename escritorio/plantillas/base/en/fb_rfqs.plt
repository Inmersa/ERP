 <form method="post" action="?seccion=rfqs" name="buscadorgeneral"> 
 <input type="hidden" name="nom_bus" value="rfqs" />

 Number <input type="text" name="nombre" size="6" class="insertext" value="@%get:st[nombre];%@" />

 @%if:AllowedAction;RFQ_id_usuario_gestor;new;%@
 Actual responsible: <input type="text" name="gestor" size="20" class="insertext" value="@%get:st[gestor];%@" />
 @%end-if:%@

 Status :
 <select name="estado" >
 <option value="">--</option>
 <option value="0"
 @%if:equals;st[estado];0;%@
 selected="selected"
 @%end-if:%@
 >Outstanding</option>
 <option value="1"
 @%if:equals;st[estado];1;%@
 selected="selected"
 @%end-if:%@
 >Opened</option>
 <option value="2"
 @%if:equals;st[estado];2;%@
 selected="selected"
 @%end-if:%@
 >Closed</option>
 </select>

 Type
 <!-- @%set:_selected_value=st[id_tipo_incidencia];%@ -->
 <select name="id_tipo_incidencia" >
 <option value="" >-----------</option>
@%where:db|crm;tabla|Tipo_incidencia;nolink|1;order|nombre;where|tipo = 1;%@
 <option value="@%db:Tipo_incidencia.id_tipo_incidencia;%@"
 @%db:selected_value{Tipo_incidencia.id_tipo_incidencia};%@
>@%db:Tipo_incidencia.nombre;%@</option>
 @%end-where:%@

 </select>

 <br>

 From: <input type="text" name="fecha_ini" size="12" maxlength="10" 
 @%if:esta_vacio;st[fecha_ini];%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st[fecha_ini];%@"
 @%end-if:%@
 />
 To: <input type="text" name="fecha_fin" size="12" maxlength="10" 
 @%if:esta_vacio;st[fecha_fin];%@
 value="dd/mm/aaaa" 
 @%else:%@
 value="@%get:st[fecha_fin];%@"
 @%end-if:%@
 />
 <a href="#" onClick="return sendForm('buscadorgeneral');" accesskey="f"  class="submit" >Search</a>

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
