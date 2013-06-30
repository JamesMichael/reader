var API = (function($) {
    var api = {};
    var base_url = '/api/';
    
    function get(path) {
        var full_url = base_url + path;
        return $.ajax({
            url: full_url,
        })
    }

    function post(path, parameters) {
        var full_url = base_url + path;

        var parameter_string = Object.keys(parameters).map(function(key){
            return key + '=' + parameters[key]
        }).join('&');

        return $.ajax({
            url: full_url,
            method: 'POST',
            data: parameter_string,
        });
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

    api.mark_read = function(item_id) {
        var request = 'items/' + item_id;
        var parameters = { 'mark-read': 1 };

        return post(request, parameters);
    };

    api.mark_unread = function(item_id) {
        var request = 'items/' + item_id;
        var parameters = { 'mark-read': 0 };

        return post(request, parameters);
    };

    return api;
}($));
