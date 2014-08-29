CREATE DATABASE IF NOT EXISTS empresa_gestion;
CREATE DATABASE IF NOT EXISTS empresa_gestion_inmersa;
GRANT  Select, Insert, Update, Delete, Create, Drop, References, Index, Alter ON empresa_gestion.* TO dblogin@'%' IDENTIFIED BY '.dbpasswd.';
GRANT  Select, Insert, Update, Delete, Create, Drop, References, Index, Alter ON empresa_gestion_inmersa.* TO dblogin_inmersa@'%' IDENTIFIED BY '.dbpasswd.';
