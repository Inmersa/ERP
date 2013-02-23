
var aCheckboxList = new Array();

function checkLink() {
	var retval = true;
	var resp = null;
	var options = '';

	// Esto hay que cambiarlo.
	var aForms = AppIface.aForms;

	// alert(' ufff ');
	for (i=0; i < aForms.length; i++) {
		if (aForms[i][1] == true) {
			resp = confirm('El formulario ' + aForms[i][0] + 
						' ha sido modificado. Ir a otro documento provocara que dichas modificaciones se pierdan. \n Desea continuar y _perder_ los cambios realizados ? ');
			if (resp) {
				retval = true;
			} else {
				send = confirm('Desea guardar los cambios realizados para proceder con el nuevo documento solicitado ? ');
				if (send) {
					options = 'menubar=1,scrollbars=1';
					target = 'SendFormbg';
					form = document.getElementById(aForms[i][0]);
					var nuevo = window.open('',target,options);
					form.target = target;
					window.focus();
					form.submit();
					// nuevo.close();
					retval = true;
				} else {
					retval = false;
				}
			}
			break;
		}
	}
	return retval;
}

function acciones_fila(thisrow) {
	var i=0;
	var j=0;
	var row;

	// Por si no se hace con AppIface
	if (thisrow.childNodes) row = thisrow;
	else row = this;
	if (row.childNodes.length) {
	   for (i=0;row.childNodes[i];i++) {
		   td = row.childNodes[i];
		   for(j=0;td.childNodes[j];j++) {
			   if (td.childNodes[j].nodeName == 'INPUT') {
				   // alert(td.childNodes[j].nodeName + ' mas ' + td.childNodes[j].form.name);
				   input = td.childNodes[j];
				   break;
			   }
		   }
	   }
	   if (input) {
		   // alert('encontrado');
		   if (selected(input)) marcar_row(row);
	   }
	}
}

function marcar_row(row) {
	if (row.className == 'trnormal') {
		row.className='trsobre';
	} else if (row.className == 'trsobre') {
		row.className='trnormal';
	}
}

function selected(checkbox) {
	var i = 0;
	var aTmp;
	var bFound = false;
	var nSpot = -1;

	if (checkbox) {
		checkbox.onClick = false;
		i = aCheckboxList.length;
		nSpot = find_checkbox(checkbox.name);
		if (nSpot == -1) { // No encontrado
			if (!checkbox.checked) {
				checkbox.checked = true;
				aTmp = new Array();
				aTmp[0] = checkbox.value;
				aTmp[1] = checkbox.name;
				aCheckboxList[aCheckboxList.length] = aTmp;
			} else {
				checkbox.checked = false;
				aTmp = new Array();
				aTmp[0] = -1;
				aTmp[1] = checkbox.name;
				aCheckboxList[aCheckboxList.length] = aTmp;
			}
		} else {
			if (!checkbox.checked) {
				checkbox.checked = true;
				aCheckboxList[nSpot][0] = checkbox.value;
			} else {
				checkbox.checked = false;
				aCheckboxList[nSpot][0] = -1;
			}
		}
	}
	return true;
}

function find_checkbox(check_name) {
	var i;
	var bFound = false;

	if (!check_name) return -1;
	if (!aCheckboxList.length) return -1;

	for (i=0; i < aCheckboxList.length; i++) {
		if (aCheckboxList[i][1] == check_name) {
			bFound = true;
			break;
		}
	}

	if (bFound) return i;
	else return -1;

}

function arrastre_paginado(form_id,pag_value) {
	var i=0;

	form = document.getElementById(form_id);
	pag_name = form.elements['nombre_variable_paginado'].value;
	form.elements[pag_name].value = pag_value;
	// alert(form.elements[pag_name].value);
	while (aTmp = aCheckboxList.pop()) {
		// alert(aTmp.length + '  -> ' + aTmp[1] + ' = ' + aTmp[0]);
		form.elements['checked_boxes'].value = form.elements['checked_boxes'].value + ' ' + aTmp[1] + '=' + aTmp[0];
	}
	form.submit();
	
	return false;
}

