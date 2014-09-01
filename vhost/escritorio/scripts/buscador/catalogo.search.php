<?php
include_inm("scripts/buscador/botonera.php");

/*Funcion de proceso de datos del formulario del buscador de catalogo */
function fd_catalogo_bo(&$obj_sesion,&$oSearch){
  global $autor;
  global $localizacion;
  global $fecha_inicio;
  global $fecha_fin;
  global $clave;
	global $hp;

	$dbname = 'db_catalogo';
	$oDb = $obj_sesion->get_db("db_catalogo");
//debug("fd_catalogo_bo");
//print_r($oDb);
// debug("nombre wolDB  = $oDb->nombre");
	if (!is_object($oDb)) {
		$dbname = 'data';
	} 
	if (!empty($dbname)) {
		$oSearch->set_db($dbname);
	} else return NULL;
//debug("porsiaca...");
// $oDb->conecta(1);

  if (empty($fecha_inicio) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_inicio,FALSE)) ) {
	  $fecha_inicio=NULL;
  }
  if (empty($fecha_fin) OR !strcasecmp('null',wol_db::formatear_fecha($fecha_fin,FALSE)) ) {
	  $fecha_fin=NULL;
  }
  if(isset($fecha_inicio) && $fecha_inicio)
   {
     $valor_inicio=split('[/-]',$fecha_inicio);
     $fecha_inicio=$valor_inicio[2]."-".$valor_inicio[1]."-".$valor_inicio[0];
     $fecha_inicio=addslashes($fecha_inicio);
     $fecha_inicio=trim($fecha_inicio);
   }
   if(isset($fecha_fin) && $fecha_fin)
   {
     $valor_fin=split('[/-]',$fecha_fin);
     $fecha_fin=$valor_fin[2]."-".$valor_fin[1]."-".$valor_fin[0];
     $fecha_fin=addslashes($fecha_fin);
     $fecha_fin=trim($fecha_fin);
   }
}

?>
