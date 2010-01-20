package Catalyst::Model::Sedna;
use Sedna;
use Moose;

extends 'Catalyst::Model';

has 'conn' => (is => 'rw',
               isa => 'Sedna',
               handles => [ 'execute',
                            'begin',
                            'rollback',
                            'getData' ]);

sub new {
  my $self = shift;
  $self = $self->SUPER::new(@_);
  my ($c, $config) = @_;

  my $conn =
    Sedna->connect($config->{url},
               $config->{db_name},
               $config->{login},
               $config->{password});

  $conn->setConnectionAttr(%{$config->{attr}})
    if $config->{attr};

  $self->conn($conn);
  return $self;
}

sub get_item {
  my $self = shift;
  if ($self->conn->next) {
    my $buf = ' 'x1024; # create the scalar in the size we want.
    my $ret = '';
    while (my $read = $self->conn->getData($buf, 1024)) {
      $ret .= substr($buf,0,$read);
    }
    return $ret;
  } else {
    return;
  }
}


42;

__END__

=head1 NAME

Catalyst::Model::Sedna - Access the Sedna XML Database

=head1 SYNOPSIS

  TODO

=head1 DESCRIPTION

This module will manage a connection to the sedna database and perform
queries. The connection attributes are set in the config file.

=head1 SEE ALSO

See the Sedna documentation, and also the Sedna bindings.

=head1 AUTHOR

Daniel Ruoso, E<lt>daniel@ruoso.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Daniel Ruoso

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
