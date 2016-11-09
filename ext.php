<?php

var_dump(geoip_country_name_by_name($_SERVER['HTTP_X_FORWARDED_FOR']));
var_dump($_SERVER['HTTP_X_FORWARDED_FOR']);
