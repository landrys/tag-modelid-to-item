package MyModules::Bean::Result;

use Moose;


has 'status' => (
    is  => 'rw',
    isa => 'Int'
);

has 'error' => (
    is  => 'rw',
    isa => 'Str'
);

has 'otherInfo' => (
    is  => 'rw',
    isa => 'Str'
);

has 'entityId' => (
    is  => 'rw',
    isa => 'Int'
);

no Moose;
__PACKAGE__->meta->make_immutable;
