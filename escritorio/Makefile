top_dir=..

DESTDIR=$(ROOT)
CLIENTE=$(CLI)
CIFRA=$(top_dir)/bin/cifra.inmersa
CAT=cat
CP=cp
RM='rm -rf'
AWK=gawk
bCifra=`cat $(top_dir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$2 }'`
KRN_KEY=`cat $(top_dir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$3 }'`
PLT_KEY=`cat $(top_dir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$4 }'`
SRC_KEY=`cat $(top_dir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$4 }'`

modulos:
	${CIFRA} -st modulos/*.inc
	${CIFRA} -st modulos/*.php

kernel: 
	${CIFRA} -st kernel/*.inc

	${CAT} kernel/db.inc > kernel_nocifrado.inc
	${CAT} kernel/accesos.inc >> kernel_nocifrado.inc
	${CAT} kernel/buscador.inc >> kernel_nocifrado.inc
	${CAT} kernel/sesiones.inc >> kernel_nocifrado.inc
	${CAT} kernel/plantillas.inc >> kernel_nocifrado.inc
# Donde esta este modulo? (tiasa?) cat modulos/notifica.inc >> modulos.clean
	${CAT} kernel/errores.inc >> kernel_nocifrado.inc
	${CAT} kernel/misc.inc >> kernel_nocifrado.inc
#cat modulos/pedidos.class.inc >> kernel.clean
#cat modulos/enlace_crm.php >> kernel.clean

	@if [ $(bCifra) -eq 0 ]; then \
	else \
		${CP} kernel_nocifrado.inc kernel.inmersa; \
		${CIFRA} -c $1 kernel.inmersa; \
		${RM} kernel_nocifrado.inc; \
	fi
#rm -rf kernel/
#rm -rf modulos/pedidos.class.inc
#rm -rf modulos/enlace_crm.php

build:
	@if [ ! -x $(CIFRA) ]; then \
		echo "$(CIFRA) no es un binario o no existe."; \
		exit 1; \
  	fi

	@if [ -z "$(CLIENTE)" ]; then \
		echo "Debe indicar un cliente para el cual empaquetar."; \
		exit 1; \
	fi
	@if [ $(bCifra) -ne 1 ]; then \
		echo "No hay nada que Cifrar."; \
		exit 1; \
	fi

	@if [ -z "$(PLT_KEY)" ]; then \
		echo "$(CLIENTE) No tiene clave de cifrado para plantillas/"; \
		exit 1; \
	fi

	@${CIFRA} -c $(PLT_KEY) plantillas/*.plt
	@${CIFRA} -st -c $(SRC_KEY) scripts/*.php
	@${CIFRA} -st -c $(SRC_KEY) scripts/buscador/*.php
	@${CIFRA} -st -c $(SRC_KEY) modulos/*.php modulos/*.inc
		

install: build
	install -m 755 -d . $(DESTDIR)
	install -m 500 getconf.sh $(DESTDIR)/
	install -m 644 index.html $(DESTDIR)/

	install -d bin $(DESTDIR)/bin
	install -m 544 bin/cifra.inmersa $(DESTDIR)/bin
        
	install -d -m 666 catalogo $(DESTDIR)/catalogo
	install -m 644 catalogo/logo.gif $(DESTDIR)/catalogo

	install -d dbs $(DESTDIR)/dbs
	install -m 600 dbs/*.* $(DESTDIR)/dbs
        
	install -d escritorio $(DESTDIR)/escritorio
	install -m 444 escritorio/config.php $(DESTDIR)/escritorio
	install -m 444 escritorio/estilos.css $(DESTDIR)/escritorio
	install -m 444 escritorio/estilosprint.css $(DESTDIR)/escritorio
	install -m 444 escritorio/index.php $(DESTDIR)/escritorio
	test -e escritorio/kernel_nocifrado.php && install -m 644 escritorio/kernel_nocifrado.php $(DESTDIR)/escritorio

	install -d escritorio/imag $(DESTDIR)/escritorio/imag
	install -m 444 escritorio/imag/*.* $(DESTDIR)/escritorio/imag
	install -d escritorio/imag/login $(DESTDIR)/imag/login
	install -m 444 escritorio/imag/login/*.* $(DESTDIR)/imag/login

	install -d escritorio/documentacion/ $(DESTDIR)/escritorio/documentacion/
	install -m 600 -D escritorio/documentacion/*.* $(DESTDIR)/escritorio/documentacion

	install -d -m 666 escritorio/documentos/ $(DESTDIR)/escritorio/documentos/

	if test -d escritorio/kernel; then \
		install -d escritorio/kernel $(DESTDIR)/escritorio/kernel; \
		install -m 444 escritorio/kernel/*.inc $(DESTDIR)/escritorio/kernel; \
	fi

	install -d escritorio/modulos $(DESTDIR)/escritorio/modulos 
	install -m 444 escritorio/modulos/*.* $(DESTDIR)/escritorio/modulos

	install -d escritorio/plantillas $(DESTDIR)/escritorio/plantillas 
	install -m 444 escritorio/plantillas/*.plt $(DESTDIR)/escritorio/plantillas

	install -d escritorio/scripts $(DESTDIR)/escritorio/scripts 
	install -m 444 escritorio/scripts/*.php $(DESTDIR)/escritorio/scripts
	install -d escritorio/scripts/buscaror $(DESTDIR)/escritorio/scripts/buscador 
	install -m 444 escritorio/scripts/buscador/*.php $(DESTDIR)/escritorio/scripts/buscador
	install -d escritorio/scripts/AccessValidation $(DESTDIR)/escritorio/scripts/AccessValidation 
	install -m 444 escritorio/scripts/AccessValidation/*.php $(DESTDIR)/escritorio/scripts/AccessValidation
