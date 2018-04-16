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
use MyModules::MyMailer;

my $NOW =  strftime "%F %T", localtime $^T;

#my $filename = 'BadModelIds';
#open(my $fh, '>', $filename) or die "Could not open file '$filename' $!";

my $modelIdUpdater = getUpdater();
$modelIdUpdater->connect();

my $itemTagSelector = getElevenCaller();
$itemTagSelector->connect();
$itemTagSelector->getItemTagsWithModelId();;

my $errors = "\n";
my $count = 0;
foreach my $itemTagModelId (@{$itemTagSelector->itemTagsModelId}) {
    my $modelId;
    eval {
        my @modelIdSplitUp = split(/:/,$itemTagModelId->tag);
        $modelId = $modelIdSplitUp[1];
        my $result = $modelIdUpdater->updateItem($modelId, $itemTagModelId->item);
        $count++;
        1;
    } || do {
        my $e = $@;
        $errors = $errors . "\n" . ' itemId:modelId ' . $itemTagModelId->item . ':' . $modelId . "\n" . $e . "\n";
    };
}

$itemTagSelector->disconnect();
$modelIdUpdater->disconnect();
say "Updated " . $count . " items.";

if (  length $errors > 5 ) {
    my $mailer = getMailer();
    $mailer->subject("Item Tag Model Id to Item Model Id FK errors");
    $mailer->body($errors);
    $mailer->sendMessage();
}

sub getElevenCaller {

    my $object = MyModules::Eleven::ItemTagModelIdMySqlCaller->new(
        archived => 0,
        database => 'eleven',
        host  => 'localhost',
        username   => 'xxxxx',
        password   => 'xxxxx',
    );

    return $object;
}


sub getUpdater {

    my $object = MyModules::Eleven::ItemModelIdUpdater->new(
        archived => 0,
        database => 'eleven',
        host  => 'localhost',
        username   => 'xxxx',
        password   => 'xxxx',
    );

    return $object;
}

sub getMailer {

    my $self = shift;

    my $object = MyModules::MyMailer->new(
        body => '',
        recipient => 'fpiergen@landrys.com',
        message => undef,

    );

    return $object;
}


