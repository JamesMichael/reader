var UI = (function($) {
    var ui = {};

	function format_item(item) {
        var content = [
             '<li id="' + item.id + '" class="item-closed">',
				'<span class="item-title"><a href="' + item.link + '">' + item.title + '</a></span>',
				'<span class="item-date">' + item.published + '</span>',
				'<span class="item-summary">' + item.content + '</span>',
			'</li>'
		].join('');

		return content;
	}

    ui.load_unread_items = function() {
        var container = $('#item_container');

		$.when(API.get_next_unread_items()).then(function(data) {
			data.items.forEach(function(item) {
				var content = format_item(item);
				container.append(content);
			});
		});
	};

    return ui;
}($));
