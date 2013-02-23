<HTML>
<HEAD>
<TITLE>INMERSA - GESTIÓN</TITLE>
<link rel="stylesheet" href="modulos/temas/inmersa/print/base.css" type="text/css" media="screen" >
<link rel="stylesheet" href="modulos/temas/inmersa/print/base.css" type="text/css" media="print" >
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
<BODY OFFonLoad="imprimirdoc();" >

<!-- @%set:clasepagina=primerapagina;%@ -->
@%where:tabla|Efectos;where|$str_where_efectos;cfunc|cf_impresion_efectos;%@
<!-- @%db:Efectos.id_efecto;%@ @%db:Efectos.id_factura;%@ @%db:Efectos.pago_cobro;%@ @%set:id_efecto=Efectos.id_efecto;%@ 
@%db:Facturas.id_cliente;%@ @%db:Facturas.id_proveedor;%@ -->
<div class="@%get:clasepagina;%@">
<!-- @%set:clasepagina=paginacabecera;%@ -->
<div id="barra1"><span class="fecha" >@%func:colocar_fecha;now;%@</span></div>

@%plt:cabprint_actores;%@

@%plt:cabprint_documento;%@

<table class="espaciarrecibo" >
<tr><td></td></tr>
</table>

<table class="fullstruct" >
<tr>
<td class="left" >
<table class="firmas">
<tr><td class="etiqueta">@%db:Empresas.razon_social;%@</td></tr>
<tr><td class="lafirma" ></td></tr>
</table>
</td>
<td class="right" >
<table class="firmas">
<tr><td class="etiqueta">Conforme Cliente</td></tr>
<tr><td class="lafirma" ></td></tr>
</table>
</td>
</tr>
</table>

</div>
@%end-where:%@

</body>
</html>
