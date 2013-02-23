<?php

class ModDistribucion extends AppModule {
	var $own_mask = 128;
	var $activo = false;
	var $entActiva = false;

	function SectionStart() {
		$oS = &$this->getApp();
		if (!is_a($oS,'wolSesion')) {
			debug("modulo distribucion, wolSesion failed  ");
			return false;
		}

		//debug("Desde modulo distribucion, _todo ok no? ");
		return true;
	}

	function ___triggerPII() {
		debug("<b>disparador</b> de punto de informacion para distribucion: ");
		return true;
	}

	function isRecordEntity ($entidad,$accion) {
		debug("La pregunta del millon ... ");
		$aList = array('Articulos');
		if (in_array($entidad,$aList)) return true;
		return false;
	}

}

?>
