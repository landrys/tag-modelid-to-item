package MyModules::MySql;

use Moose;
use v5.10.0;
no strict;
use DBI;

use warnings;

has 'database' => (
    is  => 'rw',
    isa => 'Str',
);

has 'host' => (
    is  => 'rw',
    isa => 'Str',
);

has 'user' => (
    is  => 'rw',
    isa => 'Str',
);

has 'password' => (
    is  => 'rw',
    isa => 'Str',
);

has 'connection' => (
    is  => 'rw',
    isa => 'Ref',
);


sub connect {
    my $self = shift;
    my $connectionInfo="dbi:mysql:" . $self->database() . ";"  . $self->host();
    $self->connection(DBI->connect($connectionInfo,$self->user(),$self->password()));
}

sub close {
    my $self = shift;
    $self->connection->disconnect();
}

sub prepare {
    my $self = shift;
    my $query = shift;
    $statement = $self->connection->prepare($query);
    return $statement;
}

sub do {
    my $self = shift;
    my $query = shift;
    $rowsAffected = $self->connection->do($query);
    return $rowsAffected;
}

sub print1 {

    $self = shift;
    $statement = shift;
    while (my @row = $statement->fetchrow_array)
    {
        foreach ( @row ) {
          if($_) {
           print $_.",";
          } else {
           print NULL.",";
          }
        }
        print "\n";
    }

}

sub print2 {
    $self = shift;
    $statement = shift;
    while($ref = $statement->fetchrow_hashref) {
        print join (", ", sort keys %$ref), "\n";
        print join (", ", values %$ref), "\n";
    }
}
sub print3 {
    $self = shift;
    $statement = shift;
    while($ref = $statement->fetchrow_hashref) {
        say $ref->{id};
        say $ref->{qoh};
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
