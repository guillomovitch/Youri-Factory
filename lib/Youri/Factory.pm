# $Id$
package Youri::Factory;

=head1 NAME

Youri::Factory - Factory methods

=head1 DESCRIPTION

This class provides factory methods for dynamically creating instances.

=cut

use Moose;
use MooseX::Method;
use Youri::Types;
use Youri::Error::WrongClass;
use version; our $VERSION = qv('0.1.0');

=head2 create($class, $class, %options)

Create an instance from given class with given options, after checking it
implements given interface.

=cut

method create => positional (
    { isa => 'MyClassName', required => 1 },
    { isa => 'MyClassName', required => 1 },
    { isa => 'HashRef',     required => 0 },
) => sub {
    my ($self, $interface, $class, $options) = @_;

    # check interface
    throw Youri::Error::WrongClass("class $class doesn't implement $interface") 
        unless $class->isa($interface);

    return $class->new($options ? %$options : ());
};

=head2 create_from_configuration($class, $config, %options)

Calls create after extracting class and options from given configuration
fragment.

=cut

method create_from_configuration => positional (
    { isa => 'MyClassName', required => 1 },
    { isa => 'HashRef',     required => 1 },
    { isa => 'HashRef',     required => 0 },
) => sub {
    my ($self, $interface, $config, $options) = @_;

    my $class   = $config->{class};
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
