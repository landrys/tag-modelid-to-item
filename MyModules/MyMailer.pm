package MyModules::MyMailer;

use Moose;
use 5.16.0;
use strict;
use DBI;

use Email::MIME;
use warnings;

has 'recipient' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'body' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => undef,
);

has 'message' => (
    is  => 'rw',
    isa => 'Maybe[Email::MIME]',
    default => undef,
);

has 'subject' => (
    is  => 'rw',
    isa => 'Maybe[Str]',
    default => 'Model Tree Table Update/Create Errors',
);


sub BUILD {
    my $self = shift;
}


sub buildMessage {

	my $self = shift;
	$self->message(Email::MIME->create(
			header_str => [
			From    => 'oothebigoo@gmail.com', # this does not seem to work. I thiknk system sendmail is setting this via some kind of config
			To      => $self->recipient,
			Subject => $self->subject,
			],
			attributes => {
			encoding => 'quoted-printable',
			charset  => 'ISO-8859-1',
			},
			body_str => $self->body,
			));

}

sub sendMessage {
	my $self = shift;
	buildMessage($self);
	use Email::Sender::Simple qw(sendmail);
	sendmail($self->message);
}


no Moose;
__PACKAGE__->meta->make_immutable;
