#!/usr/bin/env perl
use 5.16.0;

use Moose;


use strict;
use warnings;
use Data::Dumper;
use POSIX;
use MyModules::Bean::ModelTree;
use MyModules::Eleven::ModelTreeMysql;
use MyModules::Eleven::ModelTreeDiffer;
use MyModules::Eleven::ModelTreeUpdater;
use Data::Dumper;

my $NOW =  strftime "%F %T", localtime $^T;

my $filename = 'Info';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

my $modelTreeDuraAce = getMySqlModelTree("eleven", "xxxx", "xxxx");
$modelTreeDuraAce->connect();

my $modelTreeUltegra = getMySqlModelTree("special_orders", "xxxx", "xxxx");
$modelTreeUltegra->connect();

$modelTreeUltegra->getAll();
$modelTreeDuraAce->getAll();

$modelTreeUltegra->disconnect;
$modelTreeDuraAce->disconnect;

my $differ = MyModules::Eleven::ModelTreeDiffer->new(
    modelEntriesUltegra=>$modelTreeUltegra->modelTrees,
    modelEntriesDuraAce=>$modelTreeDuraAce->modelTrees
);

$differ->buildEntriesToUpdateAndCreate();

# Next build a model tree updater and creator object...

my $updater = MyModules::Eleven::ModelTreeUpdater->new(
    modelEntriesToUpdate => $differ->modelEntriesToUpdate,
    modelEntriesToCreate => $differ->modelEntriesToCreate);
$updater->update();


#debug();

sub debug {
    my $count=0;
    foreach my $entry (@{$differ->modelEntriesToUpdate}) {
        say Dumper($entry);
        $count++;
    }
    say $count;
    $count=0;
    foreach my $entry (@{$differ->modelEntriesToCreate}) {
        say Dumper($entry);
        $count++;
    }
    say $count;
}

sub getMySqlModelTree {

    my $database = shift;
    my $username = shift;
    my $password = shift;
    my $object = MyModules::Eleven::ModelTreeMysql->new(
        archived => 0,
        database => $database,
        host  => 'localhost',
        username   => $username,
        password   => $password,
    );

    return $object;
}
