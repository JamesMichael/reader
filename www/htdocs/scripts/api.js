var API = (function($) {
    var api = {};
    var base_url = '/api/';
    
    function get(path, callback) { 
        var full_url = base_url + path;
   
        $.ajax({
            url: full_url,
        }).done(function(data) {
            callback(data); 
        });
    }
    
    api.get_feeds = function() {
        get('feeds', function(feeds) {
            $.each(feeds.feeds, function(index, feed) {
                console.log(feed.title);
            });
        });
    };
    
    api.get_next_unread_items = function(last_unread_item_id) {
        var request = 'list/unread';
        if (last_unread_item_id !== undefined) {
            request += '/' + last_unread_item_id;
        }

        get(request, function(items) {
            $.each(items.items, function(index, item) {
                console.log(item.title);
            });
        });
    };

    return api;
}($));
