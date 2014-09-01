<table width="647" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td bgcolor="#FFFFFF" height="30"> 
		@%plt:botonera%@ 
	</td>
  </tr>
  <tr> 
    <td height="22" bgcolor="#FFFFFF">
	<form action="" name="importar_clientes_agentes" method="post">
 <input type="hidden" name="accion_ejecutar" value="Importar">
      <table width="644" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td height="22" bgcolor="#CCD2D7">&nbsp;</td>
        </tr>
        <tr>
          <td>
              <table width="644" border="0" cellspacing="0" cellpadding="0">
                <tr>
    <td>
	            <table width="643" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td bgcolor="#CCD2D7" width="1"></td>
				
			@%where:tabla|Clientes;order|Clientes.nombre,Clientes.apellidos;nombre|busc;no_results|1;%@ 
			
                        <td class="texto" height="22"> 
                          <!--@%db:Clientes.id_cliente%@-->
                          @%if:tiene_clientes_agente%@
			  @%else:%@ 
			  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                          @%end-if:%@ 
			  @%db:Clientes.nombre;%@ @%db:Clientes.apellidos;%@ 
                        </td>
                  
			  @%set:_inm_count_times=2;%@
			  @%if:inm_count%@
              </tr>
              <tr bgcolor="#CCD2D7"> 
                <td colspan="7" height="1"></td>
              </tr>
			  <tr> 
			  <td bgcolor="#CCD2D7" width="1"></td>
			  @%else:%@
			  <td bgcolor="#CCD2D7" width="1"></td>
			  @%end-if:%@
			  
			  
			  @%end-where:%@
            
			</table>
	
	</td>
                  <td width="1" bgcolor="#CCD2D7"></td>
  </tr>
</table>
          </td>
        </tr>
        <tr>
          <td height="22" bgcolor="#CCD2D7" align="center"> 
            <input type="hidden" name="Importar" value="Importar">
            </td>
        </tr>
      </table>
	  </form>
    </td>
  </tr>
  <tr> 
    <td height="30"> 
	@%plt:botonera%@
	 </td>
  </tr>
</table>

