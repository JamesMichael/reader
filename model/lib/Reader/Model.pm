package Reader::Model;
use base qw(DBIx::Class::Schema);

use Readonly;
Readonly my $DATABASE_FILE => "/opt/reader/db/reader.db";

sub model {
    my $model = Reader::Model->connect(
        "dbi:SQLite:$DATABASE_FILE",
        '',
        '',
        { sqlite_unicode => 1 },
    );
    return $model;
}

__PACKAGE__->load_namespaces;
1;
