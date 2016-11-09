<?php

require 'vendor/autoload.php';

$gi = geoip_open("/usr/share/GeoIP/GeoIP.dat", GEOIP_STANDARD);

var_dump(geoip_country_name_by_addr($gi, $_SERVER['HTTP_X_FORWARDED_FOR']));  
var_dump($_SERVER['HTTP_X_FORWARDED_FOR']);
