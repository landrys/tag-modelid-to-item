#!/usr/bin/env perl

use 5.16.0;

use strict;
use warnings;
use Data::Dumper;
use POSIX;
use MyModules::Bean::ItemTag;
use MyModules::Eleven::ItemTagModelIdMySqlCaller;
use MyModules::Eleven::ItemModelIdUpdater;
use Data::Dumper;

my $NOW =  strftime "%F %T", localtime $^T;

my $filename = 'BadModelIds';
open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

my $modelIdUpdater = getUpdater();
$modelIdUpdater->connect();

my $itemTagSelector = getElevenCaller();
$itemTagSelector->connect();
$itemTagSelector->getItemTagsWithModelId();;

my $count = 0;
foreach my $itemTagModelId (@{$itemTagSelector->itemTagsModelId}) {
    eval {
        my @modelIdSplitUp = split(/:/,$itemTagModelId->tag);
        my $modelId = $modelIdSplitUp[1];
        my $result = $modelIdUpdater->updateItem($modelId, $itemTagModelId->item);
        if ( $result->status == -1 ) {
            print $fh $modelId . ',' . $itemTagModelId->item  . "\n";
        } elsif ( $result->status == 0 ) {
            say 'Some other error occured.';
            say Dumper($result);
        } else {
            # Ok we are good
            $count++;
        }
        1;
    } || do {
        my $e = $@;
    };
}

$itemTagSelector->disconnect();
$modelIdUpdater->disconnect();
close $fh;
say "Updated " . $count . " items.";

sub getElevenCaller {

    my $object = MyModules::Eleven::ItemTagModelIdMySqlCaller->new(
        archived => 0,
        database => 'vvvvvv',
        host  => 'localhost',
        username   => 'zzzzzz',
        password   => 'wwwwww',
    );

    return $object;
}


sub getUpdater {

    my $object = MyModules::Eleven::ItemModelIdUpdater->new(
        archived => 0,
        database => 'vvvvvv',
        host  => 'localhost',
        username   => 'xxxxxx',
        password   => 'yyyyyy',
    );

    return $object;
}
