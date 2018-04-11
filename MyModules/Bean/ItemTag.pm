package MyModules::Bean::ItemTag;

use Moose;

has 'id' => (
    is  => 'rw',
    isa => 'Int',
);

has 'item' => (
    is  => 'rw',
    isa => 'Int',
);

has 'tag' => (
    is  => 'rw',
    isa => 'Str',
);

no Moose;
__PACKAGE__->meta->make_immutable;
