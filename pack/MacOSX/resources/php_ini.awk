BEGIN { 
   cerrado=0;
}

function cerrarFile() {
   if (cerrado == 0) {
      cerrado=1;
   }
}

{ 
   # Activando RegisterGlobals
   if ( $0 ~ /register_globals(.*)\=/ ) { 
      #LoadModule php4_module        libexec/httpd/libphp4.so
      if ( $0 ~ /;*register_globals(.*)/ ) {
	 gsub(/\;/,"",$0);
      }
      gsub(/\=(.*)/,"= On",$0);
      print $0;
   } else 
   # bug_compat_42 
   if ($0 ~ /bug_compat_42(.*)\= / ) {
      #Warings por RegisterGlobals
      if ( $0 ~ /;*(.*)bug_compat_42/ ) {
	 gsub(/\;/,"",$0);
      }
      gsub(/\=(.*)/,"= 0",$0);
      print $0;
   } else 
   # bug_comparet_warn 
   if ($0 ~ /bug_compat_warn(.*)\=/ ) {
      #Warings por RegisterGlobals
      if ( $0 ~ /;*(.*)bug_compat_war(.*)/ ) {
	 gsub(/\;/,"",$0);
      }
      gsub(/\=(.*)/,"= 0",$0);
      print $0;
   } else print $0;

}

END {
   if (vhostfile) cerrarFile()
}

