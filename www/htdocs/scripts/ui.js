var UI = (function($) {
    var ui = {};
    var selected_item_index = 0;

	function format_item(item) {
        var content = [
             '<li id="reader-item-id-' + item.id + '" class="item-closed" data-state="' + item.state + '">',
				'<span class="item-title">' + item.title + ' - ' + item.feed_name + '</span>',
				'<span class="item-link"><a href="' + item.link + '">' + item.title + '</a></span>',
				'<span class="item-date">' + item.published + '</span>',
				'<span class="item-summary">' + item.content + '</span>',
				'<span class="item-actions"></span>',
			'</li>'
		].join('');

		return content;
	}

	function build_action_panel(item_id) {
	    var item                 = $('#' + item_id_to_element_id(item_id));

	    // build toggle item read action
	    var item_state           = item.data('state');
	    var toggle_state_text    = item_state == 'read' ? 'Mark unread' : 'Mark read';
	    var toggle_state_element = $('<a href="javascript:void(0)" class="toggle-state">' + toggle_state_text + '</a>');

	    // replace existing toggle action
	    item.find('.item-actions .toggle-state').remove();
	    item.find('.item-actions').append(toggle_state_element);

	    // when clicking, toggle element state
	    toggle_state_element.on('click', function(event) {
	        var promise;
	        if (item_state == 'read') {
	            promise = API.mark_unread(item_id);
	        } else {
	            promise = API.mark_read(item_id);
	        }

	        promise.success(function(data) {
	            // this should probably be returned by the api
	            var new_state = item_state == 'read' ? 'unread' : 'read';
	            update_item_state(item_id, new_state);
            });
        });
    }

    function update_item_state(item_id, new_state) {
        var item = $('#' + item_id_to_element_id(item_id));
        item.data('state', new_state);

        build_action_panel(item_id);
    }

    function select_item_by_id(item_id) {
        var element_id = item_id_to_element_id(item_id);
        var item = $('#' + element_id);
        select_item(item.index());
    }

	function select_item(index) {
	    var container = $('#item_container');

	    // de-select current item
	    container.find('.item-opened').removeClass('item-opened').addClass('item-closed');

	    // select new item
	    var item = container.children().eq(index);
	    item.removeClass('item-closed').addClass('item-opened');

        selected_item_index = index;

        scroll_to_item(index);

        var item_id = element_id_to_item_id(item.attr('id'));
        build_action_panel(item_id);

        // mark item as read
        // unless the user has previously kept the item unread
        if (item.data('kept-unread') != true) {
            API.mark_read(item_id);
        }
    }

    function scroll_to_item(index) {
        var container = $('html,body');
        var item = $('#item_container').children().eq(index);
        container.scrollTop(
            item.offset().top - container.offset().top + container.scrollTop()
        );
    }

    function item_id_to_element_id(item_id) {
        return 'reader-item-id-' + item_id;
    }

    function element_id_to_item_id(element_id) {
        return element_id.match(/reader-item-id-(\d+)/)[1];
    }

    function selected_item() {
        var container = $('#item_container');
        return container.children().eq(selected_item_index);
    }

    ui.load_unread_items = function() {
        var container = $('#item_container');
        container.empty();

		$.when(API.get_next_unread_items()).then(function(data) {
			data.items.forEach(function(item) {
				var content = $(format_item(item));
				container.append(content);
				content.find('.item-title').on('click', function(event) {
				    select_item_by_id(item.id);
				});
			});

		    select_item(0);
		});
	};

	ui.select_previous = function() {
	    if (selected_item_index <= 0) {
            return;
        }

        select_item(selected_item_index - 1);
    }
    
    ui.select_next = function() {
        if (selected_item_index >= $('#item_container').children().length) {
            return;
        }

        select_item(selected_item_index + 1);
    }

    ui.toggle_read = function() {
        var item       = selected_item();
        var item_id    = element_id_to_item_id(item.attr('id'));
        var item_state = item.data('state');

        if (item_state == 'read') {
            promise = API.mark_unread(item_id);
        } else {
            promise = API.mark_read(item_id);
        }

        promise.success(function(data) {
            // this should probably be returned by the api
            var new_state = item_state == 'read' ? 'unread' : 'read';
            update_item_state(item_id, new_state);

            // the user has manually kept this item unread
            // keep track so that the item is not marked as read
            // automatically when the item is next viewed
            if (new_state == 'unread') {
                item.data('kept-unread', true);
            }
        });
	};

    return ui;
}($));
