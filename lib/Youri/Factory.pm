# $Id$
package Youri::Factory;

=head1 NAME

Youri::Factory - Factory methods

=head1 DESCRIPTION

This class provides factory methods for dynamically creating instances.

=cut

use Params::Validate qw/:all/;
use UNIVERSAL::require;
use Youri::Error::WrongClass;
use version; our $VERSION = qv('0.1.0');

=head2 create($class, $class, %options)

Create an instance from given class with given options, after checking it
implements given interface.

=cut

sub create {
    validate_pos(@_,
        1,
        {
            type => SCALAR,
            callbacks => {
                'class name' => sub { eval { $_[0]->require() } }
            }
        },
        {
            type => SCALAR,
            callbacks => {
                'class name' => sub { eval { $_[0]->require() } },
                'subclass'   => sub { $_[0]->isa($_[1]->[1]) }
            }
        },
        { type => HASHREF, optional => 1 }
    );
    my ($self, $interface, $class, $options) = @_;

    return $class->new($options ? %$options : ());
};

=head2 create_from_configuration($class, $config, %options)

Calls create after extracting class and options from given configuration
fragment.

=cut

sub create_from_configuration { 
    validate_pos(@_,
        1,
        {
            type => SCALAR,
            callbacks => {
                'class name' => sub { eval { $_[0]->require() } }
            }
        },
        {
            type => HASHREF,
            callbacks => {
                'class key' => sub { exists $_[0]->{class} },
            }
        },
        { type => HASHREF, optional => 1 }
    );
    my ($self, $interface, $config, $options) = @_;

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
