package Reader::Model::Result::Feed;
use base qw(DBIx::Class::Core);

sub feed {
    my $self = shift;

    return {
        id              => $self->id,
        uri             => $self->uri,
        title           => $self->title,
        link            => $self->link,
        description     => $self->description,
        author          => $self->author,
    };
}

__PACKAGE__->table('feed');
__PACKAGE__->add_columns(qw( id uri title link description author priority ));
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(items => 'Reader::Model::Result::Item', 'feed_id');
__PACKAGE__->has_many(fetches => 'Reader::Model::Result::Fetch', 'feed_id');
1;
