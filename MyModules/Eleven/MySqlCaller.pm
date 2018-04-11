package MyModules::Eleven::MySqlCaller;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;

has 'host' => (
    is  => 'rw',
    isa => 'Str',
);

has 'database' => (
    is  => 'rw',
    isa => 'Str',
);

has 'username' => (
    is  => 'rw',
    isa => 'Str',
);

has 'password' => (
    is  => 'rw',
    isa => 'Str',
);

has 'mysql' => (
    is  => 'rw',
    isa => 'MyModules::MySql',
);

sub connect {
    my $self = shift;
    $self->mysql->connect();
}

sub disconnect {
    my $self = shift;
    $self->mysql->close();
}

no Moose;
__PACKAGE__->meta->make_immutable;
