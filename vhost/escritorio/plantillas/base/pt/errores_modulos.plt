<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>Inmersa - Management</title>
<link rel="SHORTCUT ICON" href="imag/imagotipo.gif">
<link href="modulos/temas/inmersa/base.css" rel="stylesheet" type="text/css" media="screen" />
<link href="modulos/temas/inmersa/bordescolores.css" rel="stylesheet" type="text/css" media="screen" />
<link href="modulos/temas/inmersa/tipografia.css" rel="stylesheet" type="text/css" media="screen" />
</head>
<body>
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

<div class="barraoscurai"><a href="@%get:__error_return_link%@" class="texto">Voltar</a></div>
 
</body>
</html>
