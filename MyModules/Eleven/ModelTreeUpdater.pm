package MyModules::Eleven::ModelTreeUpdater;

use Switch;
use 5.16.0;
use strict;
use Carp;
use Data::Dumper;
use POSIX;
use MyModules::Bean::ModelTree;
use MyModules::Eleven::ModelTreeMySql;
use MyModules::MyMailer;
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

has 'modelTreeMysqlDuraAce' => (
    is  => 'rw',
    isa => 'MyModules::Eleven::ModelTreeMysql|MyModules::MySql',
);


sub BUILD { 
    my $self = shift;
    my $obj = MyModules::Eleven::ModelTreeMysql->new(
        archived => 0,
        database => 'eleven',
        host  => 'localhost',
        username   => 'xxxx',
        password   => 'xxxx',
    );

    $self->modelTreeMysqlDuraAce(${obj});
}
sub update {
    my $self = shift;
    $self->modelTreeMysqlDuraAce->connect();
    
    $self->modelTreeMysqlDuraAce->foreignKey(0);
    $self->modelTreeMysqlDuraAce->uniqueKey(0);
    my $createCount = scalar @{$self->modelEntriesToCreate};
    my $updateCount = scalar @{$self->modelEntriesToUpdate};
    say 'Creating ' . $createCount  . ' model tree entries...';
    foreach my $entry (@{$self->modelEntriesToCreate}) {
	eval { 
	    $self->modelTreeMysqlDuraAce->create($entry);
	    1;
	} || do {
	    # here you mail the fact that there is an create error.
	    my $mailer = getMailer();
	    my $e = $@;
	    $e = 'Error creating model tree entry with id: ' . $entry->id . '\n'. $e;
	    $mailer->body($e);
	    $mailer->sendMessage();
	};
    }


    say 'Udating ' . $updateCount  . ' model tree entries...';
    foreach my $entry (@{$self->modelEntriesToUpdate}) {
	eval { 
	    $self->modelTreeMysqlDuraAce->update($entry);
	    1;
	} || do {
	    # here you mail the fact that there is an update error.
	    my $mailer = getMailer();
	    my $e = $@;
	    $mailer->body($e);
	    $mailer->sendMessage();
	};
    }

    $self->modelTreeMysqlDuraAce->foreignKey(1);

    eval { 
	$self->modelTreeMysqlDuraAce->uniqueKey(1);
	1;
    } || do {
	# here you mail the fact that there is a violation of the uniqueness of full_path_name
	my $mailer = getMailer();
	my $e = $@;
	$mailer->body($e);
        $mailer->sendMessage();
    };

    $self->modelTreeMysqlDuraAce->disconnect();
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

no Moose;
__PACKAGE__->meta->make_immutable;
