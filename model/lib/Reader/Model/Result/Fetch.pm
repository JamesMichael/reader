package Reader::Model::Result::Fetch;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('fetch');
__PACKAGE__->add_columns(qw( id feed_id fetch_date filename status message ));
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(feed => 'Reader::Model::Result::Feed', 'feed_id');
1;
