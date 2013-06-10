package Reader::Model::Result::State;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('state');
__PACKAGE__->add_columns(qw( id state ));
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(items => 'Reader::Model::Result::Item', 'state_id');
1;
