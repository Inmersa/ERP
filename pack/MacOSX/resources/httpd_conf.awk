BEGIN { 
   loadmodule=0;
   addmodule=0;
   addtypephp=0;
   addtypephps=0;
   directoryindex=0;
   inmersainclude=1;
   cerrado=0;
}

function cerrarFile() {
   if (cerrado == 0) {
      if (!loadmodule) {
	 if (libdir) print "LoadModule php4_module " libdir "/libphp4.so";
      }
      if (!addmodule) {
	 print "AddModule mod_php4.c ";
      }
      if (!addtypephp) {
	 print "AddType application/x-httpd-php .php";
      }
      if (!addtypephps) {
	 print "AddType application/x-httpd-php-source .phps";
      }
      if (!directoryindex) {
	 print "DirectoryIndex index.php index.html";
      }
      if (inmersainclude && vhostfile) print "\nInclude " vhostfile;
      cerrado=1;
   }
}

{ 
   # Activando LoadModule
   if ( $0 ~ /LoadModule(.*)php4/ ) { 
      #LoadModule php4_module        libexec/httpd/libphp4.so
      if ( $0 ~ /#*LoadModule(.*)/ ) {
	 gsub(/\#/,"",$0);
      }
      loadmodule++;
      print $0;
   } else
   # Activando AddModule
   if ($0 ~ /AddModule(.*)php4(.*)/ ) {
      #AddModule mod_php4.c
      if ( $0 ~ /#*AddModule(.*)/ ) {
	 gsub(/\#/,"",$0);
      }
      addmodule++;
      print $0;
   } else 
   # AddType php
   if ($0 ~ /AddType(.*)httpd-php / ) {
      #AddType application/x-httpd-php .php
      if ( $0 ~ /#*AddType(.*)httpd-php/ ) {
	 gsub(/\#/,"",$0);
      }
      addtypephp++;
      print $0;
   } else 
   # AddType phps
   if ($0 ~ /AddType(.*)httpd-php-source/ ) {
      #AddType application/x-httpd-php-source .phps
      if ( $0 ~ /#*AddType(.*)httpd-php-source/ ) {
	 gsub(/\#/,"",$0);
      }
      addtypephps++;
      print $0;
   } else 
   # DirectoryIndex
   if ($0 ~ /DirectoryIndex/ ) {
      #DirectoryIndex index.html index.php
      if ( $0 ~ /#*DirectoryIndex/ ) {
	 gsub(/\#/,"",$0);
      }
      if ( $0 !~ /index\.php/ ) {
	 gsub(/index\.html/,"index.php index.html",$0);
      }
      directoryindex++;
      print $0;
   if ($0 ~ /NameVirtualHost/ ) {
      #NameVirtualHost *:80
      if ( $0 ~ /#*NameVirtualHost/ ) {
	 gsub(/\#/,"",$0);
      }
      print $0;
   } else 
   # Include conf files
   if ( $0 ~ /Include (.*)/ ) {
      if ( $2 == vhostfile ) {
	 inmersainclude--;
      }
      cerrarFile()
      print $0;
   } else print $0;

}

END {
   if (vhostfile) cerrarFile()
}

