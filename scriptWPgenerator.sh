#crear una carpeta "prueba" en la carpeta www
echo "===================="
echo "creando carpeta"
echo "===================="
cd /var/www
name=prueba
if [[ -e $name || -L $name ]] ; then
    i=1
    while [[ -e $name$i || -L $name$i ]] ; do
        let i++
    done
    name=$name$i
fi
mkdir -- "$name"
# entra dentro de la carpeta
# descarga wordpress
#lo descomprime en la misma carpeta
echo "===================="
echo "obteniendo wordpress"
echo "===================="
cd $name
wget http://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz
mv wordpress/* .
#crear base de datos y darle al usuario wp1 todos los permisos
echo "===================="
echo "creando BBDD"
echo "===================="
mysql -u root -p[SETHEREYOURPASSWORD] -e "create database $name"
mysql -u root -p[SETHEREYOURPASSWORD] -e "GRANT ALL PRIVILEGES ON $name.* TO '[YOURDDBB]'@'localhost' IDENTIFIED BY '[SETHEREYOURPASSWORD]'"
#create wp-config.php
WPSalts=$(wget https://api.wordpress.org/secret-key/1.1/salt/ -q -O -)
echo "
<?php
define('DB_NAME', '$name');
define('DB_USER', '[YOURDDBB]');
define('DB_PASSWORD', '[SETHEREYOURPASSWORD]');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

$WPSalts

\$table_prefix = 'try_';

define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';

" >wp-config.php

sudo chown -R www-data: .
rm latest.tar.gz
echo "===================="
echo "completado"
echo "===================="
#instalando plugins y themes
#plugins=$PWD/plugins

#themes=$PWD/themes
#wget https://downloads.wordpress.org/theme/astra.zip
#wget https://downloads.wordpress.org/theme/generatepress.zip
#tar -zxvf "./astra.zip" -C $themes
#tar -zxvf "./generatepress.zip" -C $themes