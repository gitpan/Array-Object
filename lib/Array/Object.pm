package Array::Object;

our $VERSION = '0.01';

use overload
    '@{}' => \&value,
    '+'   => \&concat,
    fallback => 1;

sub new {
    my $class = CORE::shift;
    my $value;
    if ( @_ == 1 and ref( $_[0] ) eq 'ARRAY' ) {
        $value = $_[0];
    } else {
        $value = [@_];
    }
    bless { _value => $value }, $class;
}

sub value { CORE::shift->{_value} }

sub push {
    CORE::push(@{ CORE::shift->{_value} }, @_);
}

sub pop {
    CORE::pop(@{ CORE::shift->{_value} });
}

sub shift {
    CORE::shift(@{ CORE::shift->{_value} });
}

sub unshift {
    my $self = CORE::shift;
    CORE::unshift(@{ $self->{_value} }, @_);
}

sub splice {
    my $self = CORE::shift;
    my $o = CORE::shift;
    my $l = CORE::shift;
    CORE::splice(@{ $self->{_value} }, $o, $l, @_);
}

sub length {
    scalar(@{ CORE::shift->{_value} });
}

*size = \&length;

sub reverse {
    my ( $self ) = @_;
    $self->{_value} = [ CORE::reverse(@{ $self->{_value} }) ];
}

sub copy {
    __PACKAGE__->new([ @{ CORE::shift->{_value} } ]);
}

sub join {
    CORE::join( $_[1], @{ $_[0]->{_value} } );
}

sub sort {
    my ( $self, $block ) = @_;
    if ( $block and ref $block eq 'CODE') {
        $self->{_value} = [ CORE::sort &$block, @{ $self->{_value} } ];
    } else {
        $self->{_value} = [ CORE::sort @{ $self->{_value} } ];
    }
}

sub map($&) {
    my ( $self, $block ) = @_;
    $self->{_value} = [ CORE::map &$block, @{ $self->{_value} } ];
}

sub grep($&) {
    my ( $self, $block ) = @_;
    $self->{_value} = [ CORE::grep &$block, @{ $self->{_value} } ];
}

sub concat {
    my ( $self, $other ) = @_;
    __PACKAGE__->new([ @{ $self->{_value} }, @$other ]);
}

sub contains {
    my ( $self, $thing ) = @_;
    foreach ( @{ $self->{_value} } ) {
        if ( $_ eq $thing ) {
            return 1;
        }
    }
    return 0;
}

1;

__END__

=head1 NAME

Array::Object - Array Object

=head1 SYNOPSIS

 # construction
 $array = Array::Object->new(['foo', 'bar', 'baz']); # with a reference
 
 # decorate
 $array->{foo} = 'bar';

 # treat as ARRAY ref
 push @$array, @things;     # same for pop(), shift(), splice() et al
 $array->[42] = 'boo';

 # operations - modify IN PLACE!
 $array->pop();
 $array->push( @things );
 $array->shift();
 $array->unshift( @things );
 $array->splice( ... );
 $array->sort;
 $array->sort( sub { ... } )
 
 # visitors - modify IN PLACE!
 $array->map ( CODE )       # new Array::Object
 $array->grep( CODE )       # new Array::Object
  
 # other methods
 $array->length;
 $array->size;              # same as above
 $array->copy;              # new Array::Object (shallow copy)
 $array->concat([ ... ]);   # new Array::Object (shallow copy)
 $array = $a1 + $2          # same as above
 $array->join(',');

=head1 DESCRIPTION

This module implements a simple OO interface to Arrays. The underlying
object, however, is a blessed Hash reference, but L<overload> is used for
making the object behave as an Array reference. This allows Array::Object
to be decorated and subclassed more easily.

Additionally, when the usual methods which operate on Arrays are called
as object methods, then the Array reference which is kept by the object
is B<modified in place>. Thus when you want a copy, do this:

 my @sorted = sort $@array;

which is B<NOT> the same as:

 $array->sort;

which sorts in place. Thus the OO methods are not simply syntactic sugar
(which would be kinda pointless) but have a useful semantic distinction.

=head1 METHODS

See L<SYNOPSIS>.

=head1 AUTHOR

Richard Hundt

=head1 LICENSE

This library is free software and may be used under the same terms as Perl itself

=cut
