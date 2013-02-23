<HTML>
<HEAD>
<TITLE>INMERSA - GESTIÓN</TITLE>
<link rel="stylesheet" href="modulos/temas/inmersa/print/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/print/base.css" type="text/css" media="print" >
<!-- link rel="stylesheet" href="modulos/voip/css/print.css" type="text/css" media="screen" />
<link rel="stylesheet" href="modulos/voip/css/print.css" type="text/css" media="print" />
<link rel="stylesheet" href="modulos/temas/personalizaciones/eurociber_print.css" type="text/css" media="screen" />
<link rel="stylesheet" href="modulos/temas/personalizaciones/eurociber_print.css" type="text/css" media="print" / -->
<script language="JavaScript">
function imprimirdoc() {
	printit = '@%env:printit;%@';
	if (!printit.length) return;
	if (parseInt(printit)==1) {
		window.print();
		//setTimeout('window.close()',3000);
	}
}

function recargapadre() {
	window.opener.location = window.opener.location;
}
</script>
</HEAD>
<BODY onLoad="imprimirdoc();" onUnLoad="recargapadre();">

@%set:clase_primerisima=primerapagina;%@
@%where:nodb|impresion_multiple_pedidos;format_name|classDocumentDetail;%@

@%plt:print_one_document;%@

@%end-where:%@

</body>
</html>
