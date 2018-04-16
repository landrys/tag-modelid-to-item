package MyModules::Eleven::ModelTreeMysql;

use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;
use MyModules::Bean::ModelTree;
use POSIX;

my $NOW =  strftime "%F %T", localtime $^T;
extends 'MyModules::Eleven::MySqlCaller';

 has 'modelTrees' => (
     is  => 'rw',
     isa => 'ArrayRef[MyModules::Bean::ModelTree]',
     default => sub {[]},
 );
 
sub BUILD {

    my $self = shift;

    $self->mysql(MyModules::MySql->new(
        database => $self->database,
        host  => $self->host,
        user   => $self->username,
        password   => $self->password, 
    ));

}

sub getAll {
    my $self = shift;
    my $statement = 
	    $self->mysql->prepare(
		    'select * from model_tree order by id'
			    );

    my $count = $statement->execute();
    say "Processing " . $count . " model tree entries...";

    while(my $ref = $statement->fetchrow_hashref) {
	    my $bean = MyModules::Bean::ModelTree->new;
	    $bean->id($ref->{id});
	    $bean->name($ref->{name});
	    $bean->nodeDepth($ref->{node_depth});
	    $bean->fullPathName($ref->{full_path_name});
	    $bean->leftNode($ref->{left_node});
	    $bean->rightNode($ref->{right_node});
	    $bean->parentId($ref->{parent_id});
	    push  @{$self->modelTrees}, $bean;
    }

    $statement->finish();
}

sub create {
    my $self = shift;
    my $entry = shift;
    my $statement = 
	    $self->mysql->prepare('insert into model_tree values(?,?,?,?,?,?,?)');
    $statement->execute($entry->id, $entry->name, $entry->nodeDepth, $entry->fullPathName, $entry->leftNode, $entry->rightNode, $entry->parentId);
    $statement->finish();

 
}

sub foreignKey {
    my $self = shift;
    my $fk = shift;;

    my $fkStatement = 
	    $self->mysql->prepare('set foreign_key_checks=' . $fk);
    $fkStatement->execute();
    $fkStatement->finish();
}

sub uniqueKey {
    my $self = shift;
    my $uk = shift;;

    my $ukStatement = 
    $uk == 1 ? $self->mysql->prepare('alter table model_tree add unique (full_path_name)'):$self->mysql->prepare('alter table model_tree drop index full_path_name');

    $ukStatement->execute();
    $ukStatement->finish();
}


sub update {
    my $self = shift;
    my $entry = shift;
    my $statement = 
	    $self->mysql->prepare('update model_tree set name=?,node_depth=?,full_path_name=?,left_node=?,right_node=?,parent_id=? where id=?');
    $statement->execute($entry->name, $entry->nodeDepth, $entry->fullPathName, $entry->leftNode, $entry->rightNode, $entry->parentId, $entry->id);
    $statement->finish();
}

no Moose;
__PACKAGE__->meta->make_immutable;
