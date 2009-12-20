# $Id$
package Youri::Factory;

=head1 NAME

Youri::Factory - Factory methods

=head1 DESCRIPTION

This class provides factory methods for dynamically creating instances.

=cut

use Carp;
use Moose;
use MooseX::Params::Validate;
use MooseX::Types::Moose qw/HashRef/;
use Youri::Types qw/MyClassName/;
use version; our $VERSION = qv('0.1.0');

=head2 create($class, $class, %options)

Create an instance from given class with given options, after checking it
implements given interface.

=cut

sub create {
    my $self = shift;
    my ($interface, $class, $options) = pos_validated_list(
        \@_,
        { isa => MyClassName },
        { isa => MyClassName },
        { isa => HashRef, optional => 1 },
    );

    croak "$class is not a subclass of $interface"
        unless $class->isa($interface);

    return $class->new($options ? %$options : ());
};

=head2 create_from_configuration($class, $config, %options)

Calls create after extracting class and options from given configuration
fragment.

=cut

sub create_from_configuration { 
    my $self = shift;
    my ($interface, $config, $options) = pos_validated_list(
        \@_,
        { isa => MyClassName },
        { isa => HashRef     },
        { isa => HashRef, optional => 1 },
    );

    croak "config hashref does not have a 'class' key"
        unless exists $config->{class};

    my $all_options = {
        $config->{options} ? %{$config->{options}} : (),
        $options           ? %{$options}           : ()
    };

    return $self->create(
        $interface,
        $config->{class},
        $all_options
    );
};

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2002-2006, YOURI project

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

1;
