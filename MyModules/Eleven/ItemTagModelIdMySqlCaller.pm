package MyModules::Eleven::ItemTagModelIdMySqlCaller;

use Switch;
use Moose;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use MyModules::MySql;
use MyModules::Bean::ItemTag;
use POSIX;

my $NOW =  strftime "%F %T", localtime $^T;
extends 'MyModules::Eleven::MySqlCaller';

 has 'itemTagsModelId' => (
     is  => 'rw',
     isa => 'ArrayRef[MyModules::Bean::ItemTag]',
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

sub getItemTagsModelId {
    my $self = shift;
    my $statement = 
	    $self->mysql->prepare(
		    'select * from item_tag where tag regexp \'modelid:\\d*\' order by item desc limit 3'
			    );

    $statement->execute();

    while(my $ref = $statement->fetchrow_hashref) {
	    my $bean = MyModules::Bean::ItemTag->new;
	    $bean->id($ref->{id});
	    $bean->item($ref->{item});
	    $bean->tag($ref->{tag});
	    push  @{$self->itemTagsModelId}, $bean;
    }
    $statement->finish();
}

no Moose;
__PACKAGE__->meta->make_immutable;
