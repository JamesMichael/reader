var API = (function($) {
    var api = {};
    var base_url = '/api/';
    var format   = 'json';
    
    function get(path, callback) { 
        var full_url = base_url + path + '.' + format;
   
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
    
    return api;
}($));
