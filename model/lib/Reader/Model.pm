package Reader::Model;
use base qw(DBIx::Class::Schema);

use FindBin;
use Readonly;
Readonly my $DATABASE_FILE => "$FindBin::Bin/../../model/reader.db";

sub model {
    my $model = Reader::Model->connect( "dbi:SQLite:$DATABASE_FILE" );
    return $model;
}

__PACKAGE__->load_namespaces;
1;
