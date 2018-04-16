package MyModules::Bean::ModelTree;

use Moose;

has 'id' => (
    is  => 'rw',
    isa => 'Int',
);

has 'name' => (
    is  => 'rw',
    isa => 'Str',
);

has 'nodeDepth' => (
    is  => 'rw',
    isa => 'Int',
);

has 'fullPathName' => (
    is  => 'rw',
    isa => 'Str',
);

has 'leftNode' => (
    is  => 'rw',
    isa => 'Int',
);

has 'rightNode' => (
    is  => 'rw',
    isa => 'Int',
);

has 'parentId' => (
    is  => 'rw',
    isa => 'Maybe[Int]',
    default => undef,
);

no Moose;
__PACKAGE__->meta->make_immutable;
