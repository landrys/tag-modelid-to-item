package MyModules::Eleven::ItemModelIdUpdater;

use Switch;
use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;
use MyModules::Bean::Result;
use MyModules::Bean::ItemTag;
use POSIX;

my $NOW =  strftime "%F %T", localtime $^T;
extends 'MyModules::Eleven::MySqlCaller';

sub BUILD {

    my $self = shift;

    $self->mysql(MyModules::MySql->new(
        database => $self->database,
        host  => $self->host,
        user   => $self->username,
        password   => $self->password, 
    ));

}

sub updateItem {

	my $result = MyModules::Bean::Result->new();
	my $self = shift;
	my $modelId = shift;
	my $itemId = shift;

	my $statement =
	$self->mysql->prepare(
		'update item set model_tree=? where id=?');
	my $resultExecute = $statement->execute($modelId, $itemId);

	if ( $statement->err ) {
		say $statement->errstr;
		say $statement->err;
		$result->status(0);
		$result->error($statement->errstr);
	} else {
		$result->entityId($modelId);
		$result->status(1);
		$result->otherInfo('Item id: ' . itemId . ' has been updated with model id: ' . $modelId . '.');
	}

	return $result;
}

no Moose;
__PACKAGE__->meta->make_immutable;
