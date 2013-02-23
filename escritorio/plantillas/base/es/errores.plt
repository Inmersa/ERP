
@%where:nodb|nodb_IMessages_getmsg;%@
@%if:primera_vez;%@
<div id="error" class="error">
@%end-if:%@
Error @%db:name;%@ (@%db:code;%@) : @%db:message;%@<br/>
@%set:hay_errores=1;%@
@%end-where:%@

@%if:esta_vacio;hay_errores;%@
@%else:%@
</div>
@%end-if:%@
<div class="barraoscurai"><a href="@%get:__error_return_link%@" class="texto">Volver</a></div>
 
