<?php
include_inm("scripts/buscador/botonera.php");
/** variables nombre ,id_proveedor  */
function fd_compra_articulos(&$Sesion,&$oSearch){
   $nom_bus=$Sesion->fetchVar('nom_bus','POST');
   $nombre=$Sesion->fetchVar('nombre','POST');
   $id_proveedor=$Sesion->fetchVar('id_proveedor','POST GET');
	$hp=$Sesion->fetchVar('hp','POST');
   $marca=$Sesion->fetchVar('marca','POST');
   $ida=$Sesion->fetchVar('ida','POST');
   $excluir_bajas = $Sesion->fetchVar('excluir_bajas','POST');

	$id_prov= $Sesion->get_var("id_proveedor_promocion");
   if (empty($id_proveedor)) {
      $id_proveedor =(int)$id_prov ;
	}
   if (!empty($nombre)) {
      $aSt['nombre'] = $nombre;
	}
   if (!empty($marca)) {
      $aSt['marca'] = $marca;
	}
   if (!empty($ida)) {
      $aSt['ida'] = $ida;
	}
   if (!empty($excluir_bajas)) {
      $aSt['excluir_bajas'] = $excluir_bajas;
		$oSearch->add_where('Empresas_articulos.fecha_baja IS NULL');
	}

	$oSearch->add_where('Compra_articulos.fecha_baja IS NULL');

	$Sesion->set_var('st',$aSt,'SUBSECCION');

	if (!empty($hp) AND is_numeric($hp)) {
		$Sesion->set_var('st_hp',$hp,'SUBSECCION');
		$oSearch->set_hits_page($hp);
	} else {
		$Sesion->set_var('st_hp',$oSearch->get_hits_page(),'SUBSECCION');
	}
}
?>
