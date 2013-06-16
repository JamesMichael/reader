package Reader::Model::Result::Item;
use base qw(DBIx::Class::Core);

sub item {
    my $self = shift;

    return {
        id          => $self->id,
        feed_id     => $self->feed_id,
        title       => $self->title,
        link        => $self->link,
        content     => $self->content,
        summary     => $self->content,
        published   => $self->published,
        state       => $self->state->state,
    };

}

__PACKAGE__->table('item');
__PACKAGE__->add_columns(qw( id feed_id state_id guid title link content published ));
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(feed => 'Reader::Model::Result::Feed', 'feed_id');
__PACKAGE__->belongs_to(state => 'Reader::Model::Result::State', 'state_id');
1;
