<?php
/*****************************************************************
** Aplicacion diseñada para Web On Line Studios S.L.            **
**    Todos los derechos reservados.                            **
**    Este programa se podra modificar con el consentimiento    **
**    de Web On Line Studios S.L. Su distribucion queda         **
**    limitada a Web On Line Studios S.L.		        **
**    Las posibles modificaciones sobre esta aplicacion ajenas  **
**    a Web On Line Studios S.L. deberan ser consultadas y 	**
**    enviadas a Web On Line Studios en C/Alcala 18 3º Izda,    **
**    28014 Madrid. Cualquier otra operacion realizada sobre 	**
**    esta aplicacion queda limitada a Web On Line Studios S.L. **
**    infringiendo en delito cualquier otra entidad que asi lo 	**
**    hiciese.       						**
**								**
** Para mas informacion referente a la licencia de esta 	**
**    aplicacion referirse al fichero LICENCIA. Caso de que Ud. **
**    no tenga una copia de este fichero, contacte con Web On 	**
**    Line Studios S.L. para recibir una copia del mismo	**
**							        **
** Informacion de Contacto				        **
**    Josafat Moragrega Fernandez			        **
**    Engineering					        **
**    Director Tecnico 					        **
**    tite@wolstudios.com					**
**    C/Alcala 18 3º Izda, 28014 Madrid, España		        **
**								**
** 				(c) Web On Line Studios S.L. 	**
**                                                              **
******************************************************************
*****************************************************************/

/* Esta función de visualizacion en plantilla va devolviendo la */
/* pagina a mostrar en función de los resultados y la actual    */
function nodbbotonera(&$oSesion){
   static $pagi=0;

   $suma=$oSesion->get_var("num_resultados");
	if (!$suma) $suma = numero_resultados($oSesion);
   $pag_actual=$oSesion->get_var("pag_actual");
   $hits_page=$oSesion->get_var("golpes_pag");
   if (!$pagi) {
		if (!empty($hits_page)) {
			$num_paginas=floor(($suma-1)/$hits_page);
			if (($pag_actual-10)>0) $pagi = $pag_actual-10;
			if (($pag_actual+10)<$num_paginas) $num_paginas=$pag_actual+10;
		} else {
			$num_paginas = 0;
			$pagi = $pag_actual;
		}
		$oSesion->set_var("num_paginas",$num_paginas); // expire = inmed
   } else {
		$num_paginas = $oSesion->get_var("num_paginas");
	}


   if(($pagi++) <= $num_paginas){
//   debug("numero de paginas $num_paginas");
     $resultado["num_res"] = $suma;
     $resultado["link_page"]=($pagi-1);
     $resultado["disp_page"]=$pagi;
     $resultado["pag_act"]=$pag_actual;
     return $resultado;
   }else{
     $pagi =0;
     unset($pagi);
     return NULL;
   }
}

function paginar(&$Sesion,&$aDatos){
   global $num_pag;
   $pag_actual=$Sesion->get_var("pag_actual");
   $link_page=(int)$aDatos["link_page"];
//   debug("paginar :pagina actual $pag_actual");
//   debug("paginar :pagina link $link_page");
   return ($pag_actual!=$link_page);
}

function anterior(&$Sesion,&$aDatos){
   return $Sesion->get_var("pag_actual");
}

function siguiente(&$Sesion,&$aDatos){
//debug("pillando siguiente");
     $num_pg = $Sesion->get_var("pag_actual");
     $tot_pg = $Sesion->get_var("num_paginas");
//   debug("siguiente :pagina actual $num_pg");
//   debug("siguiente :numero paginas  $tot_pg");

  if($num_pg != ($tot_pg) and ($tot_pg != -1))
        return 1;
  else return 0;
}

function pg_ant(&$Sesion,&$aDatos) {
   return ($Sesion->get_var("pag_actual")-1);
}

function pg_sig(&$Sesion,&$aDatos) {
   return ($Sesion->get_var("pag_actual")+1);
}

?>
