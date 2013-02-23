
# Rutas:
#
srcdir 	 ?= `pwd`
BUILDDIR ?= $(srcdir)/BUILD
DESTDIR  ?= $(srcdir)/BUILD
VHOST     = $(BUILDDIR)/vhost/escritorio
KRNPATH  := $(srcdir)/escritorio/kernel/
CLIENTE  ?= 'none'
INSTPATH ?= ./IEmpresa-$(CLIENTE)


# Claves de Cifrado:
#
fCifra   =`cat $(srcdir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$2 }'`
KRN_KEY	:=`cat $(srcdir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$3 }'`

PLT_KEY	:=`cat $(srcdir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$4 }'`
SRC_KEY	:=`cat $(srcdir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$5 }'`

PLTKEY	?=`cat $(srcdir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$4 }'`
SRCKEY	?=`cat $(srcdir)/claves_cifrado | grep $(CLIENTE) | awk -F : '{ print $$5 }'`

#bCifra   :=$(shell if [ ! -z "$(PLTKEY)" -o ! -z "$(SRCKEY)" ]; then echo 1; else echo 0; fi; )
#bCifra   :=$(shell if [ ! -z "$(echo $(PLTKEY))" -o ! -z "$(echo $(SRCKEY))" ]; then echo 1; else echo 0; fi; )
bCifra   :=$(shell echo 0;)

#
#  Binarios:
#CIFRA := $(srcdir)/bin/cifra.inmersa
CIFRA := $(srcdir)/bin/cifra.inmersa
CAT 	:= cat
MOVE 	:= mv
RM		:=rm
RM_OPT:=-rf
CP		:=cp
MKDIR	:=mkdir
ECHO	:=echo
AWK	:=gawk

.PHONY: lang

clean:
	-${RM} $(RM_OPT) $(INSTPATH)

checkparams:
	@if [ -z "$(CLIENTE)" ]; then \
		echo "Debe indicar el CLIENTE para el cual construir. "; \
		exit 1; \
	fi

builddirs:
	@$(call crearDirs,$(BUILDDIR))

kernel.inmersa: builddirs
	@$(call instalarDir,$(KRNPATH),$(BUILDDIR)/tmp)

	@${CIFRA} -st `ls -1 $(BUILDDIR)/tmp/*.inc`

	@${CAT} $(BUILDDIR)/tmp/db.inc > $(BUILDDIR)/kernel.inmersa 
	@${CAT} $(BUILDDIR)/tmp/accesos.inc >> $(BUILDDIR)/kernel.inmersa
	@${CAT} $(BUILDDIR)/tmp/buscador.inc >> $(BUILDDIR)/kernel.inmersa
	@${CAT} $(BUILDDIR)/tmp/sesiones.inc >> $(BUILDDIR)/kernel.inmersa
	@${CAT} $(BUILDDIR)/tmp/plantillas.inc >> $(BUILDDIR)/kernel.inmersa
	@${CAT} $(BUILDDIR)/tmp/errores.inc >> $(BUILDDIR)/kernel.inmersa
	@${CAT} $(BUILDDIR)/tmp/misc.inc >> $(BUILDDIR)/kernel.inmersa
	@${RM} $(RM_OPT) $(BUILDDIR)/tmp/


templates: builddirs
	@echo -n Copiando plantillas ... 
	$(call instalarRecursivo,$(srcdir)/escritorio/plantillas,$(VHOST)/plantillas)
	@echo " ok";

scripts: builddirs
	@echo -n Copiando scripts ... 
	$(call instalarRecursivo,$(srcdir)/escritorio/scripts,$(VHOST)/scripts)
	@echo " ok";

modulos: builddirs
	@echo -n Copiando modulos ... 
	$(call instalarRecursivo,$(srcdir)/escritorio/modulos,$(VHOST)/modulos)
	@echo " ok";

lang-all: 
	echo "hi";
	cd $(srcdir)
	${RM} ${RM_OPT} .prelang-complete/
	${RM} ${RM_OPT} .prelang-updated
	${RM} prelang/*.* 2>/dev/null
	${MAKE} "DESTDIR=$(DESTDIR)" "CLIENTE=$(CLIENTE)" "INSTPATH=$(INSTPATH)" lang-cvs; 

lang-cvs: 
	@if [ ! -d $(srcdir)/.prelang-complete ]; then ${MKDIR} $(srcdir)/.prelang-complete/; fi
	@${CP} -a $(srcdir)/.prelang-complete/. $(srcdir)/prelang/. 
	cd $(srcdir)
	@cvs status prelang/. | grep Status | grep -v Up-to-date | grep -v "no file" | awk -F ' ' '{{print $$2}}' > $(srcdir)/.prelang-updated
	@cvs status prelang/. | grep Status | grep -v Up-to-date | grep "no file" | awk -F ' ' '{{print $$4}}' >> $(srcdir)/.prelang-updated
	@if [ -s $(srcdir)/.prelang-updated ]; then \
		${RM} $(srcdir)/prelang/*.* 2>/dev/null ; \
		${RM} ${RM_OPT} $(BUILDDIR)/vhost/escritorio/plantillas/*; \
		for f in `cat .prelang-updated`; do filez="$$filez prelang/$$f"; done; cvs update -d $$filez; \
		${CP} $(srcdir)/prelang/*.* $(srcdir)/.prelang-complete/. ;\
		${MAKE} "DESTDIR=$(DESTDIR)" "CLIENTE=$(CLIENTE)" "INSTPATH=$(INSTPATH)" lang; \
	else \
		echo No changes ; \
	fi;

lang: 
	@$(MAKE) --directory=$(srcdir)/lang "DESTDIR=$(BUILDDIR)/vhost" "top_dir=$(srcdir)" all


build: builddirs kernel.inmersa templates scripts modulos
	@echo -n Copiando binarios ...
	$(call instalarDir,$(srcdir)/bin,$(BUILDDIR)/bin,500)
	@echo " ok"

	@echo -n Copiando sistema de proceso por lotes ...
	$(call instalarRecursivo,$(srcdir)/crontab,$(BUILDDIR)/crontab,400)
	@echo " ok"

	@echo -n Copiando documentacion ...
	@install -m 644 $(srcdir)/INSTALL $(BUILDDIR)/
	$(call instalarDir,$(srcdir)/escritorio/documentacion,$(BUILDDIR)/doc)
	@echo " ok"

	@echo -n Copiando BDDs ...
	$(call instalarRecursivo,$(srcdir)/dbs,$(BUILDDIR)/dbs,600)
	@install -m 600 $(srcdir)/dbs/version $(BUILDDIR)/dbs/
	@echo " ok"

	@echo -n Copiando Imagenes ... 
	$(call instalarRecursivo,$(srcdir)/escritorio/imag/,$(VHOST)/imag,444)
	@install -m 644 $(srcdir)/catalogo/*.* $(BUILDDIR)/vhost/catalogo/ 2> /dev/null
	@echo " ok"

	@echo -n Copiando Utilidades ... 
	$(call instalarRecursivo,$(srcdir)/utils,$(BUILDDIR)/vhost/utils,644)
	@echo " ok"

	@echo -n Copiando index ...
	@install -m 644 $(srcdir)/escritorio/index_cifrado.php $(BUILDDIR)/ 
	@install -m 644 $(srcdir)/escritorio/index_nocifrado.php $(BUILDDIR)/ 
	@install -m 644 $(srcdir)/escritorio/kernel_nocifrado.php $(BUILDDIR)/
	@install -m 644 $(srcdir)/index.php $(BUILDDIR)/vhost/
	@echo " ok"


#install: kernel.inmersa conf-inst 
install: checkparams
	@echo Instalando ...  
	$(call crearDirs,$(INSTPATH))
	$(call instalarRecursivo,$(BUILDDIR)/dbs,$(INSTPATH)/dbs)
	$(call instalarRecursivo,$(BUILDDIR)/vhost,$(INSTPATH)/vhost)
	$(call instalarRecursivo,$(BUILDDIR)/bin,$(INSTPATH)/bin)
	$(call instalarRecursivo,$(BUILDDIR)/doc,$(INSTPATH)/doc)
	$(call instalarRecursivo,$(BUILDDIR)/crontab,$(INSTPATH)/crontab)

	$(if $(shell if [ $(bCifra) -eq 1 ]; then echo "yes"; fi;),$(call cifraRecursivo,$(PLTKEY),$(INSTPATH)/vhost/escritorio/plantillas))
	$(if $(shell if [ $(bCifra) -eq 1 ]; then echo "yes"; fi;),$(call cifraStripDir,$(SRCKEY),$(INSTPATH)/vhost/escritorio/scripts))
	$(if $(shell if [ $(bCifra) -eq 1 ]; then echo "yes"; fi;),$(call cifraStripDir,$(SRCKEY),$(INSTPATH)/vhost/escritorio/scripts/buscador))
	$(if $(shell if [ $(bCifra) -eq 1 ]; then echo "yes"; fi;),$(call cifraStripDir,$(SRCKEY),$(INSTPATH)/vhost/escritorio/modulos))
	$(if $(shell if [ $(bCifra) -eq 1 ]; then echo "yes"; fi;),$(call cifraStripDir,$(SRCKEY),$(INSTPATH)/vhost/escritorio/modulos/voip/src))

	$(call cifrarKernel,$(KRN_KEY),$(INSTPATH))

	@install -m 600 $(BUILDDIR)/INSTALL $(INSTPATH)/
	@install -m 600 $(BUILDDIR)/dbs/version $(INSTPATH)/dbs/

	$(call generarConf,$(INSTPATH))

define generarConf
	@echo -n "Generando configuracion de BDD ... "
	@echo "# " > $(1)/conf/configvars 
	@echo "## Variables de Configuracion de iEmpresa " >> $(1)/dbs/configvars
	@echo "# " >> $(1)/conf/configvars 
	@echo "_USEFULL_CONFIG=n" >> $(1)/conf/configvars
	@echo " ok"

	@echo -n "Generando configuracion de Aplicacion ... "
	@echo "<?php" > $(1)/vhost/escritorio/config.php
	@echo "\$$login='login_bdd_inmersa';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$passwd='passwd_bdd_inmersa';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$cfgServer='dns_sql_server';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$dbase='bdd_inmersa';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$port='sql_port';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$cfgDbase='_main';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$APP_NAME='IEmpresa_$(CLIENTE)';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$mod_path='modulos/';" >> $(1)/vhost/escritorio/config.php
	@echo "\$$BACKOFFICE=TRUE;" >> $(1)/vhost/escritorio/config.php
	@echo "\$$DEBUG='Off';" >> $(1)/vhost/escritorio/config.php
	@echo "?>" >> $(1)/vhost/escritorio/config.php

	@echo "CLIENTE=$(CLIENTE)" > $(1)/conf/configure.files
	@echo 'CONF_FILE=$$(echo $$CFGPATH)/configvars' >> $(1)/conf/configure.files
	@echo 'GRANT_FILE=$$(echo $$CFGPATH)/dbgrants' >> $(1)/conf/configure.files
	@echo 'STRUCT_FILE=$$(echo $$srcdir)/dbs/gestion.struct.sql' >> $(1)/conf/configure.files
	@echo 'DEFAULTS_FILE=$$(echo $$srcdir)/dbs/gestion.default.sql' >> $(1)/conf/configure.files
	@echo 'DBCFG_FILE=$$(echo $$srcdir)/dbs/gestion_inmersa.sql' >> $(1)/conf/configure.files
	@echo 'INM_FILE=$$(echo $$CFGPATH)/update_main' >> $(1)/conf/configure.files
	@echo 'SITE_FILE=$$(echo $$INSTALL_DIR)/vhost/escritorio/config.php' >> $(1)/conf/configure.files
	@echo " ok"

	@$(if $(shell if [ $(bCifra) -eq 1 ]; then echo "yes"; fi;),install -m 644 $(BUILDDIR)/index_cifrado.php $(1)/vhost/escritorio/index.php,install -m 644 $(BUILDDIR)/index_nocifrado.php $(1)/vhost/escritorio/index.php)
endef

define cifrarKernel
	@if [ $(bCifra) -eq 1 ]; then \
		if [ ! -z "$(1)" ]; then \
			if [ "$(2)" != "$(BUILDDIR)" ]; then \
				${CP} $(BUILDDIR)/kernel.inmersa $(2)/; \
			fi; \
			${CIFRA} -c $(1) $(2)/kernel.inmersa; \
		fi; \
	else \
		install -m 644 $(BUILDDIR)/kernel_nocifrado.php $(2)/vhost/escritorio/; \
		${ECHO} "<?php" > $(2)/vhost/escritorio/kernel_nocifrado.inc; \
		${CAT} $(BUILDDIR)/kernel.inmersa >> $(2)/vhost/escritorio/kernel_nocifrado.inc; \
		${ECHO} "?>" >> $(2)/vhost/escritorio/kernel_nocifrado.inc; \
	fi;
endef

define cifraStripDir
@${CIFRA} -st -c $(1) $(2)/*.*; 
endef

define cifraDir
@${CIFRA} -c $(1) $(2)/*.*; 
endef

define cifraRecursivo
@for d in `ls -1RF $(2) | grep / | grep -v CVS | grep : | awk -F ':' '{{print $$1}}'`;do \
	if [ ! -z "`ls -F1 $$d/ | grep -v /`" ]; then \
		${CIFRA} -c $(1) $$d/*.* ; \
	fi; \
done; 
endef

define cifraStripRecursivo
@for d in `ls -1RF $(2) | grep / | grep -v CVS | grep : | awk -F ':' '{{print $$1}}'`;do \
	if [ ! -z "`ls -F1 $$d/ | grep -v /`" ]; then \
		${CIFRA} -st -c $(1) $$d/*.* ; \
	fi; \
done; 
endef

define instalarRecursivo
@if [ ! -d "$(1)" ]; then exit 0; fi; \
if [ -z "$(3)" ]; then perms='644'; else perms="$(3)"; fi; \
cd $(1); \
for d in `find . -type d | grep -v CVS`; do \
	if [ ! -d "$(2)/$$d" ]; then install -m 755 -d $(2)/$$d || exit; fi; \
	for f in `find $(1)/$$d -maxdepth 1 -type f`; do install -m $$perms $$f $(2)/$$d/. 2>/dev/null ; done; \
done; \
exit 0;
endef

#install -m $$perms $(1)/$$d/*.* $(2)/$$d/. 2> /dev/null ; \
#install -m $$perms $(wildcard $(1)/$$d/*.*) $(2)/$$d/. 2> /dev/null ; \

define instalarDir
@if [ -z "$(3)" ]; then perms='644'; else perms="$(3)"; fi; \
if [ ! -d "$(2)" ]; then install -m 755 -d $(2)/ ; fi; \
filez=`find $(1) -type f | grep -v CVS`; \
if [ ! -z "$$filez" ]; then install -m $$perms $(wildcard $(1)/*.*) $(2)/; fi;\
exit 0;
endef

define crearDirs
	@install -m 755 -d $(1)/ $(1)/bin $(1)/doc $(1)/dbs $(1)/dbs/backups $(1)/conf $(1)/crontab
	@install -m 755 -d \
		$(1)/vhost \
		$(1)/vhost/escritorio \
		$(1)/vhost/escritorio/imag \
		$(1)/vhost/escritorio/imag/login \
		$(1)/vhost/escritorio/imag/iconos \
		$(1)/vhost/escritorio/modulos \
		$(1)/vhost/escritorio/modulos/temas \
		$(1)/vhost/escritorio/modulos/locale \
		$(1)/vhost/escritorio/scripts \
		$(1)/vhost/escritorio/scripts/buscador \
		$(1)/vhost/escritorio/scripts/AccessValidation \
		$(1)/vhost/escritorio/plantillas 
	@install -m 1777 -d \
		$(1)/vhost/catalogo \
		$(1)/vhost/escritorio/documentos \
		$(1)/vhost/escritorio/documentos/albaranes \
   	$(1)/vhost/escritorio/documentos/facturas \
   	$(1)/vhost/escritorio/documentos/pedidos
endef


