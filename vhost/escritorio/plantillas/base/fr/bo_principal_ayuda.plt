<HTML>
<HEAD>
<TITLE>@%db:Ayuda.nombre%@</TITLE>
<script language="javascript" src="modulos/temas/list_iface.js">
</script>
<link rel="stylesheet" href="modulos/temas/estilos.css" type="text/css">
</HEAD>
<link rel="stylesheet" href="estilos.css" type="text/css">
<body bgcolor="#FFFFFF" text="#000000" leftmargin="8" topmargin="5" marginwidth="5" marginheight="5">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td class="titocho" width="100%" height="22" bgcolor="#91CC00">-@%db:Ayuda.antetitulo%@</td>
  </tr>
  <tr> 
    <td class="etiqueta" width="100%" height="22" bgcolor="#DBE0E3" >-@%db:Ayuda.titulo%@</td>
  </tr>
  <tr><td height="10"></td></tr>
  <tr> 
    <td class="texto" width="100%" height="22">>>@%db:Ayuda.cuerpo%@</td>
  </tr>
</table>
<br/>
<table>
  @%where:tabla|Ayuda_epigrafes;%@ 
  <!-- @%db:Ayuda_epigrafes.id_imagen;%@ @%db:Ayuda_epigrafes.id_epigrafe;%@-->
  <tr> 
    <td height="22" class="etiqueta" colspan="2"> -@%db:Ayuda_epigrafes.titulo%@ 
    </td>
  </tr>
  <tr> 
    <td>
	@%where:tabla|Catalogo_imagenes;%@ 
	<img src="/catalogo/@%db:Catalogo_imagenes.nombre%@"> 
	 @%end-where:%@ 
	
	  </td>
    <td class="texto">@%db:Ayuda_epigrafes.cuerpo%@</td>
  </tr>
  @%end-where:%@ 
  
</table>
</BODY>
</HTML>

