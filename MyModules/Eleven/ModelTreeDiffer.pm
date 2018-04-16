package MyModules::Eleven::ModelTreeDiffer;

use Switch;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use POSIX;
use MyModules::Bean::ModelTree;
use Moose;

my $NOW =  strftime "%F %T", localtime $^T;

has 'modelEntriesToUpdate' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::ModelTree]',
    default => sub {[]},
);

has 'modelEntriesToCreate' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::ModelTree]',
    default => sub {[]},
);

has 'modelEntriesUltegra' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::ModelTree]',
    default => sub {[]},
);

has 'modelEntriesDuraAce' => (
    is  => 'rw',
    isa => 'ArrayRef[MyModules::Bean::ModelTree]',
    default => sub {[]},
);

sub BUILD {}

sub buildEntriesToUpdateAndCreate {
    my $self = shift;
my $count_update = 0;
my $count_create = 0;
    foreach my $modelTreeU (@{$self->modelEntriesUltegra}) {
        my $mt = findInDura($self, $modelTreeU);
        if ( $mt ) {
            if ( isDifferent($modelTreeU, $mt) ) {
                $count_update++;
                push $self->modelEntriesToUpdate, $modelTreeU;
            }
        } else {
            # new entry
            $count_create++;
            push $self->modelEntriesToCreate, $modelTreeU;
        }
    }

}

sub findInDura {
    my $self = shift;
    my $mt = shift;
    foreach my $modelTreeD (@{$self->modelEntriesDuraAce}) {
        if ($mt->id == $modelTreeD->id) {
            return $modelTreeD;
        }
    }
    return 0;
}

sub isDifferent {

    my $mtU = shift;
    my $mtD = shift;
    my $uPid = 0;
    my $dPid = 0;
    $uPid = (defined $mtU->parentId ? 1:0);
    $dPid = (defined $mtD->parentId ? 1:0);

    if ( ($uPid + $dPid) == 0 ) {
        # both undefined
        if ($mtU->name eq $mtD->name && 
            $mtU->nodeDepth == $mtD->nodeDepth && 
            $mtU->fullPathName eq $mtD->fullPathName && 
            $mtU->leftNode == $mtD->leftNode && 
            $mtU->rightNode == $mtD->rightNode ) {
            return 0;
        } else {
            return 1;
        }
    } elsif( ($uPid + $dPid) == 1 ) {
        # one undefined which means that they are different
        return 1;
    } else {
        # both defined
        if ($mtU->name eq $mtD->name && 
            $mtU->nodeDepth == $mtD->nodeDepth && 
            $mtU->fullPathName eq $mtD->fullPathName && 
            $mtU->leftNode == $mtD->leftNode  &&
            $mtU->rightNode == $mtD->rightNode &&
            $mtU->parentId == $mtD->parentId ) {
            return 0;
        } else {
            return 1;
        }
    }
}


no Moose;
__PACKAGE__->meta->make_immutable;
