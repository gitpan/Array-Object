# vim: set ft=perl:
use lib './lib';
use Test::More qw(no_plan);

use Array::Object;

my $array0 = Array::Object->new([ 'foo', 'bar' ]);
ok( ref($array0) eq 'Array::Object' );
ok( $array0->size == 2 );
$array0->push( 'baz' );
ok( $array0->size == 3 );
ok( $array0->[2] eq 'baz' );
my $foo = $array0->shift();
ok( $foo eq 'foo' );
my $baz = pop @$array0;
ok( $baz eq 'baz' );

ok($array0->length == 1);
$array0->splice( 0, 0, 'quux' );

$array0->map( sub { $_ . '_added' } );
ok( $array0->[0] eq 'quux_added' );
ok( $array0->[1] eq 'bar_added' );

my $array1 = $array0 + Array::Object->new(['foo', 'baz']);
ok($array1->[0] eq 'quux_added');
ok($array1->[1] eq 'bar_added');
ok($array1->[2] eq 'foo');
ok($array1->[3] eq 'baz');
ok($array0->size == 2);
ok(@$array1 == 4);

my $array2 = Array::Object->new([ 1, 2, 3 ]);
$array2->reverse;
ok( $array2->[0] == 3 );
ok( $array2->[1] == 2 );
ok( $array2->[2] == 1 );

my $array3 = $array2->copy;
$array3->sort;
ok( $array3->[0] == 1 );
ok( $array3->[1] == 2 );
ok( $array3->[2] == 3 );

