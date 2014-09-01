

 <form method="post" action="?seccion=@%get:_krn_ss_name;%@" name="buscadorgeneral">
<input type="hidden" name="nom_bus" value="documentosCRM" />
 Text<input type="text" name="texto" size="20" value="@%get:st[texto];%@" />
 Search Type <!-- @%set:_selected_value=st[id_tipo_documento];%@ -->
 <select name="id_tipo_documento">
 <option value="">No selection</option>
 @%where:db|crm;tabla|Tipos_documento;nolink|1;order|nombre;%@
 <option value="@%db:Tipos_documento.id_tipo_documento;%@"
 @%db:selected_value{Tipos_documento.id_tipo_documento};%@
 >@%db:Tipos_documento.nombre;%@</option>
 @%end-where:%@

 </select>

 Search Group <!-- @%set:_selected_value=st[id_agrupacion_documentos];%@ -->
 <select name="id_agrupacion_documentos">
 <option value="">No selection</option>
 @%where:db|crm;tabla|Agrupaciones_documentos;nolink|1;order|nombre;%@
 <option value="@%db:Agrupaciones_documentos.id_agrupacion_documentos;%@"
 @%db:selected_value{Agrupaciones_documentos.id_agrupacion_documentos};%@
 >@%db:Agrupaciones_documentos.nombre;%@</option>
 @%end-where:%@

 </select>
 <a href="#" onclick="return sendForm('buscadorgeneral');" accesskey="f" class="submit" >Search</a>
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

