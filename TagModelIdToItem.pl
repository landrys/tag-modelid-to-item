#!/usr/bin/env perl

use 5.16.0;
use lib 'auto-lib', 'lib';
use JSON::Parse 'json_file_to_perl';

use strict;
use warnings;
use Paws;
use Data::Dumper;
use POSIX;
use MyModules::Bean::ItemTag;
use MyModules::Eleven::ItemTagModelIdMySqlCaller;
use Data::Dumper;

my $NOW =  strftime "%F %T", localtime $^T;

# get the open HPs from eleven specialOrders DB

my $modelIdUpdater = get
my $caller = getElevenCaller();
$caller->connect();
$caller->getItemTagsModelId();;

foreach my $itemTagModelId (@{$caller->itemTagsModelId}) {
	eval {
		say (Dumper($itemTagModelId));
		updateItemModelTreeEntry($itemTagModelId->tag);
		1;
	} || do {
		my $e = $@;
		say $e;
	};
}

$caller->disconnect();

sub getElevenCaller {

    my $object = MyModules::Eleven::ItemTagModelIdMySqlCaller->new(
        archived => 0,
        database => '',
        host  => '',
        username   => '',
        password   => '',
    );

    return $object;
}

sub updateItemModelTreeEntry {

	my $modelIdTag = shift;
	my @modelIdSplitUp = split(/:/,$modelIdTag)[0];
	my $modelId = $modelIdSplitUp[1];
	say $modelId;
	my $statement = 
		$self->mysql->prepare(
				'update item set model_tree="' . $modelId . ' where id="' . $itemId);
	$statement->execute();
        $statement->finish();




 my $model = shift;
        my $result = MyModules::Bean::Result->new();

        my $statement = $elevenDB->prepare("insert into item_location_scan_cp values(?,?,?,?,?,?,?,?,?)");
        my $resultExecute = $statement->execute(
                        $model->id(),
                        $model->serialized(),
#                       1, 
                        $model->scan_location(),
                        $model->destination_location(),
                        $model->employee(),
                        $model->action(),
                        $model->timestamp(),
                        $model->last_modified(),
                        0
                      0
                        );

        if ( $statement->err ) {
                say $statement->errstr;
                say $statement->err;
                $result->status(0);
                $result->error($statement->errstr);
        } else {
                $result->entityId($model->id());
                $result->status(1);
                $result->otherInfo('Model with id ' . $model->id . ' created in duraAce.');
        }

        return $result;

}



