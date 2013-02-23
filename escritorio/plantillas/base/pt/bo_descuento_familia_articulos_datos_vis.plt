<table width="647" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td height="22" bgcolor="#FFFFFF"> 
      <table width="644" border="0" cellspacing="0" cellpadding="0" bgcolor="#CCD2D7">
        <form name="descuentos_familia" method="post" action="">
          <input type="hidden" name="accion_ejecutar" value="0" class="texto">
          <tr> 
            <td align="right" class="texto" height="22">&nbsp;&nbsp;</td>
          </tr>
          <tr> 
            <td bgcolor="#FFFFFF"> 
              <table width="644" border="0" cellspacing="0" cellpadding="0">
                <tr > 
                  <td bgcolor="#EBECED" colspan="3"  height="22"></td>
                </tr>
                <tr> 
                  <td height="1" colspan="3"></td>
                </tr>
                <tr> 
                  <td bgcolor="#EBECED" width="100">&nbsp;</td>
                  <td width="1"></td>
                  <td> 
                    <table width="542" border="0" cellspacing="0" cellpadding="0">

                      @%where:nodb|listar_descuentos_familia;%@ 

                      <tr> 
                        <td bgcolor="#EBECED" width="24" align="center">&nbsp; </td>
                        <td rowspan="2" width="1"> </td>
                        <td width="285" class="etiqueta" bgcolor="#EBECED" height="22">&nbsp;&nbsp;@%db:Familia_articulos.nombre;%@</td>
                        <td width="61" class="texto" bgcolor="#EBECED"> 
                          @%db:Cliente_familia_articulos.descuento;%@<input type="hidden" name="descuentos_familia_modificar[@%db:Cliente_familia_articulos.id_familia%@]" value="@%db:Cliente_familia_articulos.descuento;%@" size="4" class="insertextnumeros">
                          % </td>
                        <td width="1" class="texto"></td>
                        <td width="170" class="texto" align="center" bgcolor="#EBECED">&nbsp; 
                      </tr>
                      <tr> 
                        <td height="1" align="center" bgcolor="#EBECED" width="24"></td>
                        <td height="1" colspan="2"></td>
                        <td height="1" width="1"></td>
                        <td height="1" bgcolor="#EBECED" width="170"></td>
                      </tr>

                      @%end-where:%@ 

                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td align="center" height="18"></td>
          </tr>
        </form>
      </table>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF" height="25"></td>
  </tr>
</table>