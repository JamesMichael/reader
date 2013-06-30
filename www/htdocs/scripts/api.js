var API = (function($) {
    var api = {};
    var base_url = '/api/';
    
    function get(path) {
        var full_url = base_url + path;
        return $.ajax({
            url: full_url,
        })
    }
    
    api.get_feeds = function() {
        return get('feeds');
    };
    
    api.get_next_unread_items = function(last_unread_item_id) {
        var request = 'list/unread';
        if (last_unread_item_id !== undefined) {
            request += '/' + last_unread_item_id;
        }

        return get(request);
    };

    return api;
}($));
