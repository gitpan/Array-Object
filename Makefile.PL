use inc::Module::Install;

name('Array-Object');
author('Richard Hundt <richard NO SPAM AT protea-systems.com>');
abstract('Array Object');
license('artistic');
version_from('lib/Array/Object.pm');

check_nmake();
&WriteAll();
