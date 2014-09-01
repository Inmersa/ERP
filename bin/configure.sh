#!/bin/bash
CFGPATH=$(pwd)/conf
CFGFILES=configure.files
MYSQL="$(which mysql|grep -v 'no mysql')"
AWK=$(which gawk|grep -v 'no gawk');
if [ -z "$AWK" ]; then AWK=$(which awk|grep -v 'no awk'); fi;

# Valores por defecto:
QUIET=0;

# Figure out how to do 'echo' without newline:
c=''
n=''
if [ "`eval echo -n 'a'`" = "-n a" ] ; then
						c='\c'
else
						n='-n'
fi

# Check if ${VAR:-def} works
DUMMY_VAR=""
DUMMY_VAR2="some value"
DUMMY_VAR=${DUMMY_VAR:-test}
DUMMY_VAR2=${DUMMY_VAR2:-test}
if [ "$DUMMY_VAR" != "test" -o "$DUMMY_VAR2" != "some value" ]; then
  echo "You /bin/sh doesn't understand '\${VAR:-default}'"
  exit 1
fi


#
# comment does some pretty-printing
#
#						comment 'xxx'
#
comment () {
  echo ""
  echo "*-----------------------------------------------------------------------------";
  echo -e "* $1" ;
  echo "*"
}

function check_bool() {
    _bool='';
    if [ "$1" = "s" -o "$1" = "si" -o "$1" = "S" -o "$1" = "Si" -o "$1" = "SI"  -o "$1" = "y" -o "$1" = "yes" -o "$1" = "Y" -o "$1" = "Yes" -o "$1" = "YES" -o "$1" = "1" ]; then
        _bool=1;
    else
        if [ "$1" = "n" -o "$1" = "no" -o "$1" = "N" -o "$1" = "No" -o "$1" = "NO" -o "$1" = "0" ]; then
            _bool=0;
        else
            test ! -z "$2" && _bool=$2 || _bool=0;
        fi;
    fi;
}

#
# readln reads a line into $ans.
#
#	readln macro prompt default oldval
#
readln () {
  echo $1 | $AWK '{ printf("%-20.20s: ", $1); }'
  if [ "$USE_DEFAULT" != "n" -a -n "$4" ]; then
   echo $n "$2"
   [ -z "$4" -a -z "$3" ] && echo $n "($c) " || [ -z "$4" -a ! -z "$3" ] && echo $n "($3) " || echo $n "($4) "
	echo $c
   [ ! -z "$4" ] && ans=$4
	[ -z "$ans" ] && ans=$3
  else
    echo $n "$2$c"
    [ -z "$4" -a -z "$3" ] && echo $n "($c) " || [ -z "$4" -a ! -z "$3" ] && echo $n "($3) " || echo $n "($4) "
    IFS='@' read ans </dev/tty || exit 1
    [ -z "$ans" ] && ans=$4
    [ -z "$ans" ] && ans=$3
  fi
}

parse_arguments() {
    for arg do
        case "$arg" in
            -q|--quiet=*)
                QUIET=1;
            ;;
            --prefix=*)
                INSTALL_DIR=`echo "$arg" | sed -e "s;--prefix=;;"`;
                srcdir=$INSTALL_DIR;
            ;;
            --cfgpath=*)
                CFGPATH=`echo "$arg" | sed -e "s;--cfgpath=;;"`;
            ;;
        esac
    done;
#--basedir=*) MY_BASEDIR_VERSION=`echo "$arg" | sed -e "s;--basedir=;;"` ;;
}

generate_default_conf() {
    if [ ! -z "$1" ]; then
        CFG=$1/$2;
cat<<EOF>$CFG
VHOSTPATH=$CFGPATH/../vhost
CFGPATH=$1
CONF_FILE=$CFGPATH/configure.cfg
GRANT_FILE=$CFGPATH/grants.sql
INM_FILE=$CFGPATH/app_config.sql
SITE_FILE=$CFGPATH/../vhost/escritorio/config.php
DEFAULTS_FILE=$CFGPATH/../dbs/gestion.default.sql
DBCFG_FILE=$CFGPATH/../dbs/gestion_inmersa.sql
EOF
    else
        echo "Missing argument to generate_default_conf . " >> /dev/stderr;
    fi;
}


if [ ! -f "$CFGPATH/$CFGFILES" ]; then
    # Si no hemos encontrado la configuracion, miramos los parametros
    parse_arguments "$@"
    if [ ! -f "$CFGPATH/$CFGFILES" ]; then
        echo "No configuration file found, creating this one $CFGPATH/$CFGFILES ";
        install -d $CFGPATH;
        generate_default_conf $CFGPATH $CFGFILES;
        . $CFGPATH/$CFGFILES
#        echo "Error: config file $CFGFILES not found. Use --cfgpath switch ";
#        exit 1;
    fi;
fi;

if [ -z "$srcdir" ]; then srcdir=$(pwd); fi;
if [ -z "$INSTALL_DIR" ]; then INSTALL_DIR=$(pwd); fi;

. $CFGPATH/$CFGFILES

if [ -z "$MYSQL" -o ! -x "$MYSQL" ]; then \
    echo "Error: mysql client not found"; \
    exit 1; \
fi


if [ -e "$CONF_FILE" ]; then
    . $CONF_FILE;
    parse_arguments "$@"
    if [ -z "$_USEFULL_CONFIG" ]; then
        _USEFULL_CONFIG=n;
    fi
    check_bool $_USEFULL_CONFIG;
    if [ $_bool -eq 1 ]; then
        if [ $QUIET -ne 1 ]; then
            readln "CHANGE_CONF" "Tiene una configuracion almacenada. Desea usarla? [s/n]" "n" "";
            check_bool $ans;
            if [ $_bool -eq 1 ]; then
                USE_DEFAULT=y;
            else
                USE_DEFAULT=n;
            fi;
        else
            USE_DEFAULT=y;
        fi;
    else
        USE_DEFAULT=n
        if [ $QUIET -eq 1 ]; then
            echo "No USEFULL_CONFIG Found on $CONF_FILE" > /dev/stderr;
            exit 1;
        fi;
    fi
else
    parse_arguments "$@"
#    generate_default_conf "$CFGPATH" "$CFGFILES";
#    echo "We run the configuration file now, since we didnt have that chance ";
#    . $CFGPATH/$CFGFILES;
    if [ $QUIET -eq 1 ]; then
        echo "No USEFULL_CONFIG Found on $CONF_FILE" > /dev/stderr;
        exit 1;
    fi;
fi

if [ $QUIET -ne 1 ]; then
    #Lo primero configuramos los Privilegios de la DDBB
    readln "DB_HOST" "dns o ip del host MySQL [localhost] " "localhost" "$MYSQL_HOST"
    MYSQL_HOST=$ans
    readln "DB_PORT" "puerto MySQL del host $MYSQL_HOST " "3306" "$MYSQL_PORT"
    MYSQL_PORT=$ans
    readln "MYSQL_SU_USER" "Login de usuario privilegiado en la DDBB [root] " "root" "$MYSQL_SU_USER"
    MYSQL_SU_USER=$(echo "$ans")
    readln "MYSQL_SU_PASS" "Contrase�a del usuario en $MYSQL_SU_PASS la DDBB [$MYSQL_SU_USER] " "" "$MYSQL_SU_PASS"
    MYSQL_SU_PASS=$(echo "$ans")
    readln "DB_NAME" "Nombre de la BBDD [$(echo $CLIENTE)_gestion] " "$(echo $CLIENTE)_gestion" "$DBNAME"
    DBNAME=$ans
    readln "DB_LOGIN" "Nombre de usuario para la DB $DBNAME -Max 12 Car.- " "$(echo $CLIENTE)gt" "$DBLOGIN"
    DBLOGIN=$ans
    readln "DB_PASSWORD" "Contrase�a del usuario $DBLOGIN " "" "$DBPW"
    DBPW=$ans
    readln "DB_CLIENT_HOST" "mascara MySQL de acceso para $DBLOGIN en $MYSQL_HOST " "$MYSQL_HOST" "$DBMASK"
    DBMASK=$ans
    readln "IGestion_User" "Login de aplicacion -Usuario privilegiado- " "$CLIENTE" "$IG_LOGIN"
    IG_LOGIN=$ans
    readln "IGestion_Password" "Contrase�a de aplicacion para el usuario [$IG_LOGIN] " "$IG_PW" "$IG_PW"
    IG_PW=$ans

    if [ -f "$DBCFG_FILE" ]; then
        oldifs=$IFS;
        IFS="
"
        msg="Idioma por defecto de la aplicacion: "
        for l in `cat $DBCFG_FILE | grep -E "INSERT INTO(.*)Idiomas" | grep -v Relaciones | $AWK -F "'" '{{print $2" ["$4"]\n"}}'`; do
            msg="$msg $l";
        done;
        IFS=$oldifs;
        readln "IGestion_Language" "$msg" "es" "$LANG"
        LANG=$ans
    fi;
    IFACE='nav';

    DBNAME_INM=$(echo $DBNAME)_inmersa
    DBLOGIN_INM=$(echo $DBLOGIN)_inm
    DBPW_INM=$(echo $DBPW)
    IG_APP_NAME=IGestion_$CLIENTE

    readln "do_CRM_CONFIG" "Si tiene Ud. Licencia de iCRM. Desea configurar el enlace iEmpresa->iCRM ahora? [s/n]" "s" ""
    check_bool $ans
    CFG_CRM=$_bool
    if [ "$CFG_CRM" -eq 1 ]; then
    # Enlace con iCRM
        readln "ICRM_VHOST" "Nombre del VHost (uri) para iCRM [icrm.$(echo $CLIENTE).com] " "icrm.$(echo $CLIENTE).com" "$ICRM_VHOST"
        ICRM_VHOST=$ans
        readln "ICRM_DBNAME" "Nombre la BBDD para iCRM " "$(echo $CLIENTE)_crm" "$ICRM_DBNAME"
        ICRM_DBNAME=$ans
        readln "CRMDB_LOGIN" "Nombre de usuario para la DB $ICRM_DBNAME -Max 12 Car.- " "$(echo $CLIENTE)cr" "$ICRM_DBLOGIN"
        ICRM_DBLOGIN=$ans
        readln "CRMDB_PASSWORD" "Contrase�a del usuario para la DB $ICRM_DBLOGIN " "$ICRM_DBPW" "$ICRM_DBPW"
        ICRM_DBPW=$ans

        ICRM_DBNAME_INM=$(echo $ICRM_DBNAME)_inmersa
        ICRM_DBLOGIN_INM=$(echo $ICRM_DBLOGIN)_inm
        ICRM_DBPW_INM=$(echo $ICRM_DBPW)
    fi;

    readln "do_ICONTA_CONFIG" "Si tiene Ud. Licencia de iConta. Desea configurar el enlace iEmpresa->iConta ahora? [s/n]" "s" ""
    check_bool $ans
    CFG_iConta=$_bool
    if [ "$CFG_iConta" -eq 1 ]; then
    # Enlace con iCRM
        readln "ICONTA_VHOST" "Nombre del VHost (uri) para iCONTA " "iconta.$(echo $CLIENTE).com" "$ICONTA_VHOST"
        ICONTA_VHOST=$ans
        readln "ICONTA_DBNAME" "Nombre la BBDD para iCONTA " "$(echo $CLIENTE)_contabilidad" "$ICONTA_DBNAME"
        ICONTA_DBNAME=$ans
        readln "CONTADB_LOGIN" "Nombre de usuario para la DB $ICONTA_DBNAME -Max 12 Car.- " "$(echo $CLIENTE)ct" "$ICONTA_DBLOGIN"
        ICONTA_DBLOGIN=$ans
        readln "CONTADB_PASSWORD" "Contrase�a del usuario $ICONTA_DBLOGIN " "$ICONTA_DBPW" "$ICONTA_DBPW"
        ICONTA_DBPW=$ans

        ICONTA_DBNAME_INM=$(echo $ICONTA_DBNAME)_inmersa
        ICONTA_DBLOGIN_INM=$(echo $ICONTA_DBLOGIN)_inm
        ICONTA_DBPW_INM=$(echo $ICONTA_DBPW)
    fi;

    #echo Preguntar tambien por el idioma (krncfg_default_lang), iface (krncfg_default_iface) y tema (krncfg_default_theme) por defecto.
else
    if [ ! -z "$ICRM_VHOST" ]; then CFG_CRM=1; else CFG_CRM=0; fi;
    if [ ! -z "$ICONTA_VHOST" ]; then CFG_iConta=1; else CFG_iConta=0; fi;
fi;

if [ "$QUIET" -ne 1 ]; then
    comment "A Continuacion se procedera a volcar por completo la configuracion de iEmpresa.
    Si ya tiene datos almacenados, estos se perderan."
    readln "do_DBDUMP" "Desea continuar? [s/n]" "s" ""
    check_bool $ans
    DO_DUMP=$_bool
else
    DO_DUMP=1;
fi;

cat<<EOF>$CONF_FILE
_USEFULL_CONFIG=1
MYSQL_HOST='$(echo $MYSQL_HOST)'
MYSQL_PORT='$(echo $MYSQL_PORT)'
MYSQL_SU_USER='$(echo $MYSQL_SU_USER)'
MYSQL_SU_PASS='$(echo $MYSQL_SU_PASS)'
DBNAME='$(echo $DBNAME)'
DBLOGIN='$(echo $DBLOGIN)'
DBPW='$(echo $DBPW)'
DBMASK='$(echo $DBMASK)'
IG_LOGIN='$(echo $IG_LOGIN)'
IG_PW='$(echo $IG_PW)'
DBNAME_INM='$(echo $DBNAME_INM)'
DBLOGIN_INM='$(echo $DBLOGIN_INM)'
DBPW_INM='$(echo $DBPW_INM)'
IG_APP_NAME='$(echo $IG_APP_NAME)'
ICRM_VHOST='$(echo $ICRM_VHOST)'
ICRM_DBNAME='$(echo $ICRM_DBNAME)'
ICRM_DBLOGIN='$(echo $ICRM_DBLOGIN)'
ICRM_DBPW='$(echo $ICRM_DBPW)'
ICRM_DBNAME_INM='$(echo $ICRM_DBNAME_INM)'
ICRM_DBLOGIN_INM='$(echo $ICRM_DBLOGIN_INM)'
ICRM_DBPW_INM='$(echo $ICRM_DBPW_INM)'
ICONTA_VHOST='$(echo $ICONTA_VHOST)'
ICONTA_DBNAME='$(echo $ICONTA_DBNAME)'
ICONTA_DBLOGIN='$(echo $ICONTA_DBLOGIN)'
ICONTA_DBPW='$(echo $ICONTA_DBPW)'
ICONTA_DBNAME_INM='$(echo $ICONTA_DBNAME_INM)'
ICONTA_DBLOGIN_INM='$(echo $ICONTA_DBLOGIN_INM)'
ICONTA_DBPW_INM='$(echo $ICONTA_DBPW_INM)'
LANG='$(echo $LANG)'
IFACE='$(echo $IFACE)'
EOF

if [ "$DO_DUMP" -eq 1 ]; then

    if [ "$QUIET" -ne 1 ]; then
        readln "do_DBBACKUP" "Desea hacer backup de los datos? [s/n]" "s" "";
        check_bool $ans;
        DO_BKP=$_bool;
    else
        DO_BKP=1;
    fi;
    if [ "$DO_BKP" -eq 1 ]; then
        echo "Haciendo backup de datos ... "
        if [ $QUIET -ne 1 ]; then
            bin/backup_data.sh
        else
            bin/backup_data.sh -q
        fi;
    fi;

    if [ ! -z "$MYSQL_PORT" ]; then portinfo="-P $MYSQL_PORT"; fi;

    MYCMD=`echo $MYSQL -u "$MYSQL_SU_USER" --password="$MYSQL_SU_PASS" -h $MYSQL_HOST $portinfo`
    DBV=`cat dbs/version`;
    DBSTRUCT="dbs/V$DBV/estructura.sql"
    if [ ! -z "$DBV" -a -f "$DBSTRUCT" ]; then
        STRUCT_FILE=$DBSTRUCT;
        OLDDBV=`echo "SELECT valor FROM _main WHERE nombre='database_version'" | $MYCMD $DBNAME_INM 2>/dev/null | grep -v valor;`
        if [ -z "$OLDDBV" ]; then
            echo "No habia DB version. asumiento primera instalacion ";
            OLDDBV="";
        fi;
        if [ ! -z "$OLDDBV" ]; then
        if [ "$OLDDBV" -ne "$DBV" ]; then
            CURDBV=$OLDDBV;
            echo "actualizando DB version desde $OLDDBV a $DBV ";
            while [ "$CURDBV" -ne "$DBV" ]; do
                if [ "$CURDBV" -lt "$DBV" ]; then
                    let NEWDBV=$CURDBV+1
                    #echo "subiendo DB de $CURDBV a $NEWDBV .. ";
                    accion="upgrade"
                else
                    let NEWDBV=$CURDBV-1
                    #echo "bajando DB de $CURDBV a $NEWDBV .. ";
                    accion="downgrade"
                fi;
                CURDBV=$NEWDBV
                sqlscr=dbs/V$NEWDBV/pre$accion.data.sql;
                if [ -f "$sqlscr" ]; then
                    echo "Ejecutando $sqlscr contra $DBNAME ";
                    cat $sqlscr | $MYCMD $DBNAME ;
                fi;
                sqlscr=dbs/V$NEWDBV/pre$accion.conf.sql;
                if [ -f "$sqlscr" ]; then
                    echo "Ejecutando $sqlscr contra $DBNAME_INM ";
                    cat $sqlscr | $MYCMD $DBNAME_INM ;
                fi;
                if [ "$DBV" -eq "$NEWDBV" ]; then
                    echo "Ya hemos llegado a la version actual. Los scripts para el final. "
                    sqlscr=dbs/V$NEWDBV/post$accion.data.sql;
                    if [ -f "$sqlscr" ]; then
                        POST_DBSCRIPT_DATA=$sqlscr
                    fi;
                    sqlscr=dbs/V$NEWDBV/post$accion.conf.sql;
                    if [ -f "$sqlscr" ]; then
                        POST_DBSCRIPT_CONF=$sqlscr
                    fi;
                else
                    echo "FixMe: Pendiente de actualizar conf antes de ejecutar post-scripts de versiones intermedias "
                    sqlscr=dbs/V$NEWDBV/post$accion.data.sql;
                    if [ -f "$sqlscr" ]; then
                        echo "Ejecutando $sqlscr contra $DBNAME ";
                        cat $sqlscr | $MYCMD $DBNAME ;
                    fi;
                    sqlscr=dbs/V$NEWDBV/post$accion.conf.sql;
                    if [ -f "$sqlscr" ]; then
                        echo "Ejecutando $sqlscr contra $DBNAME_INM ";
                        cat $sqlscr | $MYCMD $DBNAME_INM ;
                    fi;
                fi;
            done;
        fi;
        fi;
    else
        echo "NO DATABASE VERSION FOUND";
    fi;

echo "Generating Grant file $GRANT_FILE ";
cat<<EOF>$GRANT_FILE
CREATE DATABASE IF NOT EXISTS $DBNAME;
CREATE DATABASE IF NOT EXISTS $(echo $DBNAME_INM);
GRANT  ALL PRIVILEGES
    ON $DBNAME.*
    TO $DBLOGIN@'$DBMASK'
    IDENTIFIED BY '$DBPW';
GRANT  ALL PRIVILEGES
    ON $DBNAME_INM.*
    TO $DBLOGIN_INM@'$DBMASK'
    IDENTIFIED BY '$DBPW_INM';
EOF

cat<<EOF>$INM_FILE
REPLACE INTO Users (id_usr,nombre,login,passwd,av_group,activo)
    VALUES (1,'$CLIENTE','$IG_LOGIN',PASSWORD('$IG_PW'),4,1);
USE $DBNAME;
INSERT INTO Empresarios (id_empresa,id_usr,nombre) VALUES (1,1,'Default User');
USE $DBNAME_INM;
DELETE FROM _main WHERE nombre='app_name' OR nombre like 'db_data_%'
					  OR nombre='doc_root' OR nombre='root_dir'
					  OR nombre='krncfg_default_lang' OR nombre='krncfg_default_iface'
					  OR nombre='krncfg_doc_root'
					  OR nombre = 'database_version'
					  OR nombre = 'db_crm_login'
					  OR nombre = 'db_crm_passwd'
					  OR nombre = 'db_crm_dbase'
					  OR nombre = 'db_crm_server'
					  OR nombre = 'db_crm_port'
					  OR nombre = 'crm_link'
					  OR nombre = 'crm_mask_coordinador'
					  OR nombre = 'crm_mask_empleado'
					  OR nombre = 'crm_mask_externo'
					  OR nombre = 'db_crmcfg_login'
					  OR nombre = 'db_crmcfg_passwd'
					  OR nombre = 'db_crmcfg_dbase'
					  OR nombre = 'db_crmcfg_port'
					  OR nombre = 'db_crmcfg_server'
					  OR nombre = 'cfg_app_iconta_dbconname'
					  OR nombre = 'cfg_app_iconta_dbcfgconname'
					  OR nombre = 'cfg_app_iconta_dbname'
					  OR nombre = 'cfg_app_iconta_dbcfgname'
					  OR nombre = 'db_iconta_login'
					  OR nombre = 'db_iconta_passwd'
					  OR nombre = 'db_iconta_dbase'
					  OR nombre = 'db_iconta_server'
					  OR nombre = 'db_iconta_port'
					  OR nombre = 'db_icontacfg_login'
					  OR nombre = 'db_icontacfg_passwd'
					  OR nombre = 'db_icontacfg_dbase'
					  OR nombre = 'db_icontacfg_port'
					  OR nombre = 'db_icontacfg_server';

INSERT INTO _main(nombre,valor) VALUES
('app_name','$IG_APP_NAME'),
('database_version','$DBV'),
('db_data_server','$MYSQL_HOST'),
('db_data_port','$MYSQL_PORT'),
('db_data_dbase','$DBNAME'),
('db_data_login','$DBLOGIN'),
('db_data_passwd','$DBPW'),
('doc_root','$(echo $INSTALL_DIR)/vhost/'),
('root_dir','$(echo $INSTALL_DIR)/vhost/'),
('krncfg_doc_root','$(echo $INSTALL_DIR)/vhost/'),
('krncfg_default_lang','$LANG'),
('krncfg_default_iface','$IFACE');

EOF

if [ $CFG_CRM -eq 1 ]; then
cat <<EOF>>$INM_FILE
#Enlace con el CRM:
INSERT INTO _main(nombre,valor) VALUES
('db_crm_login','$ICRM_DBLOGIN'),
('db_crm_passwd','$ICRM_DBPW'),
('db_crm_dbase','$ICRM_DBNAME'),
('db_crm_server','$MYSQL_HOST'),
('db_crm_port','$MYSQL_PORT'),
('crm_link','http://$ICRM_VHOST/escritorio/'),
('crm_mask_coordinador','16'),
('crm_mask_empleado','12'),
('crm_mask_externo','3'),
('db_crmcfg_login','$ICRM_DBLOGIN_INM'),
('db_crmcfg_passwd','$ICRM_DBPW_INM'),
('db_crmcfg_dbase','$ICRM_DBNAME_INM'),
('db_crmcfg_server','$MYSQL_HOST'),
('db_crmcfg_port','$MYSQL_PORT');
EOF
else
cat <<EOF>>$INM_FILE
#SIN enlace con CRM:
UPDATE Sub_Plts set deny_mask = 2147483647 WHERE nombre='incidencias';
EOF
fi

if [ $CFG_iConta -eq 1 ]; then
cat <<EOF>>$INM_FILE
#Enlace con la Contabilidad:
INSERT INTO _main(nombre,valor) VALUES
('db_iconta_login','$ICONTA_DBLOGIN'),
('db_iconta_passwd','$ICONTA_DBPW'),
('db_iconta_dbase','$ICONTA_DBNAME'),
('db_iconta_server','$MYSQL_HOST'),
('db_iconta_port','$MYSQL_PORT'),
('db_icontacfg_login','$ICONTA_DBLOGIN_INM'),
('db_icontacfg_passwd','$ICONTA_DBPW_INM'),
('db_icontacfg_dbase','$ICONTA_DBNAME_INM'),
('db_icontacfg_server','$MYSQL_HOST'),
('db_icontacfg_port','$MYSQL_PORT'),
('cfg_app_iconta_dbname','iconta'),
('cfg_app_iconta_dbcfgname','icontacfg');
EOF
fi

cat<<EOF>$SITE_FILE
<?php
\$login="$DBLOGIN_INM";
\$passwd="$DBPW_INM";
\$cfgServer="$MYSQL_HOST";
\$port="$MYSQL_PORT";
\$cfgDbase="_main";
\$dbase="$DBNAME_INM";
\$APP_NAME="$IG_APP_NAME";
\$mod_path="modulos/";
\$BACKOFFICE=TRUE;
\$DEBUG="Off";
?>
EOF

##TODO: Preguntar si desea hacer una BackUp de los Datos antes.
   if [ $QUIET -ne 1 ]; then echo $n "Creating Grants ..."; fi;
   cat $GRANT_FILE | $MYCMD || exit 1
   if [ $QUIET -ne 1 ]; then echo " ok"; fi;

   if [ $QUIET -ne 1 ]; then echo $n "Creating Database structure ..."; fi;
   cat $STRUCT_FILE | $MYCMD $DBNAME || exit 1
   if [ $QUIET -ne 1 ]; then echo " ok"; fi;

   if [ $QUIET -ne 1 ]; then echo $n "Creating Company profile ..."; fi;
   echo "INSERT INTO Empresas(id_empresa,nombre) VALUES (1,'$CLIENTE');" | $MYCMD $DBNAME || exit 1
   if [ $QUIET -ne 1 ]; then echo " ok"; fi;

   if [ $QUIET -ne 1 ]; then echo $n "Dumping Database default values ..."; fi;
   cat $DEFAULTS_FILE | $MYCMD $DBNAME || exit 1
   if [ $QUIET -ne 1 ]; then echo ok; fi;

   if [ $QUIET -ne 1 ]; then echo $n "Dumping configuration ..."; fi;
   cat $DBCFG_FILE | $MYCMD $DBNAME_INM || exit 1
   if [ $QUIET -ne 1 ]; then echo ok; fi;

   if [ $QUIET -ne 1 ]; then echo $n "Updating configuration ..."; fi;
   cat $INM_FILE | $MYCMD $DBNAME_INM || exit 1
   if [ $QUIET -ne 1 ]; then echo " ok"; fi;

    if [ ! -z "$POST_DBSCRIPT_DATA" ]; then
        echo "Ejecutando script de datos $POST_DBSCRIPT_DATA "
        cat $POST_DBSCRIPT_DATA | $MYCMD $DBNAME ;
    fi;

    if [ ! -z "$POST_DBSCRIPT_CONF" ]; then
        echo "Ejecutando script de datos $POST_DBSCRIPT_CONF "
        cat $POST_DBSCRIPT_CONF | $MYCMD $DBNAME_INM ;
    fi;
fi;

