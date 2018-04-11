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
use constant FOREIGN_KEY_MYSQL_CONSTRAINT_ERROR => 1452;

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

	my $self = shift;
	my $result = MyModules::Bean::Result->new();
	my $modelId = shift;
	my $itemId = shift;

	my $statement =
	$self->mysql->prepare(
		'update item set model_tree=? where id=?');

	my $resultExecute = $statement->execute($modelId, $itemId);

        if ( $statement->err ) {
            if ( checkIfForeignKeyViolation($statement->err, $modelId, $itemId)) {
                $result->status(-1);
            } else {
                $result->status(0);
            }
            $result->error($statement->errstr);
	} else {
		$result->entityId($modelId);
		$result->status(1);
		$result->otherInfo('Item id: ' . $itemId . ' has been updated with model id: ' . $modelId . '.');
	}

	return $result;
}

sub checkIfForeignKeyViolation {
    my $errorCode = shift;
    my $modelId = shift;
    my $itemId = shift;

    if ( $errorCode == FOREIGN_KEY_MYSQL_CONSTRAINT_ERROR ) {
        say ('******');
        say('*** This is a constraint error for item id: ' . $itemId . ' and model id: ' . $modelId );
        say ('******');
        return 1;
    } else {

        say ('++++++');
        say('+++ This is some other  error for item id: ' . $itemId . ' and model id: ' . $modelId );
        say ('++++++');
        return 0;
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
