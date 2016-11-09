## Setup

1. Use the Vagrantfile to create your box.
2. Add the domains the benchmarks use to the box `/etc/hosts` file:
   - apache.maxmind
   - phplib.maxmind
   - phpext.maxmind
   - vanilla.maxmind
3. Run `sudo /vagrant/provision.sh` on the box.

## Test

```
$ curl -H "X-Forwarded-For: your.source.ip.address.here" http://phplib.maxmind
```

## Benchmark

We use [Siege](https://github.com/JoeDog/siege):

```
$ siege -H "X-Forwarded-For: your.source.ip.address.here" -c 50 -t 60s http://apache.maxmind
```

To test with and without the Composer autoloader, remove the `require
'vendor/autoload.php';` line from the appropriate PHP files.

To test the GeoIP PHP extension, enable it and restart Apache:

```
$ sudo ln -sf /vagrant/geoip.ini /etc/php5/conf.d/10-geoip.ini
$ sudo service apache2 restart
```
