<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>INMERSA - MANAGEMENT</title>
<link rel="SHORTCUT ICON" href="imag/imagotipo.png">
<meta http-equiv="Content-Script-Type" content="text/javascript" >
<script type="text/javascript" src="modulos/temas/inmersa/Browsers.js" ></script>
<script type="text/javascript" src="modulos/temas/inmersa/IfaceActions.js" ></script>
<script type="text/javascript" src="modulos/temas/inmersa/Tabs.js" ></script>

<link rel="stylesheet" href="modulos/temas/inmersa/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/tablas.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/imagenes.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/iconografia.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/menus.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/formularios.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/fichas.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/bordescolores.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/tipografia.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/graficas.css" type="text/css" media="screen" >

<link rel="stylesheet" href="modulos/temas/inmersa/@%func:css_hacks;%@" type="text/css" media="screen" >

<link rel="stylesheet" href="modulos/temas/inmersa/iconografia.css" type="text/css" media="print" >
<link rel="stylesheet" href="modulos/temas/inmersa/bordesycolores.css" type="text/css" media="print" >
<link rel="stylesheet" href="modulos/temas/inmersa/formularios.css" type="text/css" media="print" >
<link rel="stylesheet" href="modulos/temas/inmersa/tipografia.css" type="text/css" media="print" >
<link rel="stylesheet" href="modulos/temas/inmersa/print/base.css" type="text/css" media="print" >
<link rel="stylesheet" href="modulos/temas/inmersa/print/@%func:css_hacks;%@" type="text/css" media="print" >

@%if:esta_vacio;LinkCRM;%@
@%else:%@
<link rel="stylesheet" href="modulos/temas/inmersa/CRM.css" type="text/css" media="screen" >
@%end-if:%@

<link rel="stylesheet" href="modulos/temas/personalizaciones/voip/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/personalizaciones/voip/print.css" type="text/css" media="print" >

<script >
<!-- 
oCache = new refCache();
// -->
</script>
</head>
<body offonLoad="AppIface.linkEventToAction('link','onclick',checkLink);"> 
@%plt:bbo_seccion%@ 
</body>
</html>
