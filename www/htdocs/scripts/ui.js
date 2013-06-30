var UI = (function($) {
    var ui = {};
    var selected_item_index = 0;

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

	function select_item(index) {
	    var container = $('#item_container');

	    // de-select current item
	    container.find('item-opened').removeClass('item-opened').addClass('item-closed');

	    // select new item
        container.children().eq(index).removeClass('item-closed').addClass('item-opened');
    }

    ui.load_unread_items = function() {
        var container = $('#item_container');
        container.empty();

		$.when(API.get_next_unread_items()).then(function(data) {
			data.items.forEach(function(item) {
				var content = format_item(item);
				container.append(content);
			});

		    selected_item_index = 0;
		    select_item(selected_item_index);
		});
	};

    return ui;
}($));
