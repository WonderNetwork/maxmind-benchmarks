#!/bin/bash

set -e

# install deps
apt-get install -y build-essential apache2 php5 php5-dev siege php-pear build-essential autoconf libtool apache2-threaded-dev curl

# link apache configs
ln -sf /vagrant/mpm-prefork.conf /etc/apache2/conf.d/mpm-prefork.conf
ln -sf /vagrant/apache.maxmind /etc/apache2/sites-enabled/apache.maxmind
ln -sf /vagrant/phplib.maxmind /etc/apache2/sites-enabled/phplib.maxmind
ln -sf /vagrant/phpext.maxmind /etc/apache2/sites-enabled/phpext.maxmind
ln -sf /vagrant/vanilla.maxmind /etc/apache2/sites-enabled/vanilla.maxmind

# link php config
ln -sf /vagrant/opcache.ini /etc/php5/conf.d/10-opcache.ini

# make sure any pre-existing geoip php extension is disabled, or it'll break
# composer
rm -f /etc/php5/conf.d/10-geoip.ini

# get the maxmind geoip database
rm -rf geoipcountry.dat
mkdir -p /usr/share/GeoIP
wget -O geoipcountry.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
gunzip geoipcountry.dat.gz
mv geoipcountry.dat /usr/share/GeoIP/GeoIP.dat

# set up the geoip legacy library from maxmind
rm -rf GeoIP-1.6.9
wget -O maxmind-library.tar.gz https://github.com/maxmind/geoip-api-c/releases/download/v1.6.9/GeoIP-1.6.9.tar.gz
tar -zxf maxmind-library.tar.gz
cd GeoIP-1.6.9
./configure
make
make install
cd ..

# set up the apache module from maxmind
rm -rf geoip-api-mod_geoip2-1.2.10
wget -O maxmind-module.tar.gz https://github.com/maxmind/geoip-api-mod_geoip2/archive/1.2.10.tar.gz
tar -zxf maxmind-module.tar.gz
cd geoip-api-mod_geoip2-1.2.10
apxs2 -i -a -L/usr/local/lib -I/usr/local/include -lGeoIP -c mod_geoip.c
cd ..

# get the php geoip module from pecl
pecl install -s geoip || true

# get composer
wget -O composer-installer https://getcomposer.org/installer
php composer-installer --install-dir=/usr/local/bin --filename=composer --version=1.1.3

# install the geoip library (before we actually enable the extension, because
# that makes it break)
cd /vagrant
composer install -o

# restart apache
service apache2 restart
