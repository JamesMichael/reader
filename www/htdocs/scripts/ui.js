var UI = (function($) {
    var ui = {};
    var selected_item_index = 0;
    var unread_count = 0;
    var is_refreshing = false;

    $('#refresh-button').on('click', function(event) {
        UI.load_unread_items();
    });
    
    function two_digit_number(number) {
        return number < 10 ? '0' + number : number;
    }
    
    function timestamp_to_datestring(timestamp) {
        var date = new Date(timestamp * 1000);
        var date_string = [
            two_digit_number(date.getHours()) + ':' + two_digit_number(date.getMinutes()),
            date.getDate() + '/' + (date.getMonth() + 1)
        ].join(' ');
        return date_string;
    }

    function format_item(item) {
        var content = [
             '<li id="reader-item-id-' + item.id + '" class="item-closed" data-state="' + item.state + '">',
                '<div class="item-head">',
                    '<i class="glyphicon glyphicon-star-empty item-star"></i>',
                    '<span class="item-feed-name visible-lg">' + item.feed_name + '</span>',
                    '<span class="item-published visible-lg">' + timestamp_to_datestring(item.published) + '</span>',
                    '<span class="item-title">' + item.title + '</span>',
                '</div>',
                '<div class="item-actions"></div>',
                '<span class="item-link"><a href="' + item.link + '" target="_blank">' + item.title + '</a></span>',
                '<span class="item-date">' + item.published + '</span>',
                '<div class="item-summary clearfix">' + item.content + '</div>',
            '</li>'
        ].join('');

        return content;
    }

    function build_action_panel(item_id) {
        var item                 = $('#' + item_id_to_element_id(item_id));

        // build toggle item read action
        var item_state           = item.data('state');
        var toggle_state_text    = 'read';
        var toggle_state_icon    = item_state == 'unread' ? 'glyphicon-unchecked' : 'glyphicon-check';
        var toggle_state_element = $([
            '<a href="javascript:void(0)" class="toggle-state">',
                '<i class="glyphicon ' + toggle_state_icon + '"></i>&nbsp;',
                toggle_state_text,
            '</a>'
        ].join(''));

        // update the item star ui based on the 'star' state
        if (item.data('state') == 'starred') {
            item.find('.item-star').attr('class', 'glyphicon glyphicon-star item-star');
        } else {
            item.find('.item-star').attr('class', 'glyphicon glyphicon-star-empty item-star');
        }

        // add a click handler to the star icon
        item.find('.item-star').unbind('click');
        item.find('.item-star').on('click', function(event) {
            if (event) {
                event.stopPropagation();
                event.preventDefault();
            }

            toggle_star(item_state, item_id);

            return false;
        });

        // replace existing toggle action
        item.find('.item-actions .toggle-state').remove();
        item.find('.item-actions').append(toggle_state_element);

        // when clicking, toggle element state
        toggle_state_element.on('click', function(event) {
            var promise;
            if (item_state == 'unread') {
                promise = API.mark_read(item_id);
            } else {
                item.data('kept-unread', true);
                promise = API.mark_unread(item_id);
            }

            promise.success(function(data) {
                // this should probably be returned by the api
                var new_state = item_state == 'unread' ? 'read' : 'unread';
                update_item_state(item_id, new_state);
            });
        });
    }

    function update_item_state(item_id, new_state) {
        var item = $('#' + item_id_to_element_id(item_id));
        var old_state = item.data('state');

        if (new_state == 'unread' && old_state != 'unread') {
            increment_unread_count();
        } else if (new_state != 'unread' && old_state == 'unread') {
            decrement_unread_count();
        }

        item.data('state', new_state);

        build_action_panel(item_id);
    }

    function select_item_by_id(item_id) {
        var element_id = item_id_to_element_id(item_id);
        var item = $('#' + element_id);
        select_item(item.index());
    }

    function update_unread_counter() {
        $('#item-count').html(unread_count);
    }

    function decrement_unread_count() {
        unread_count--;
        update_unread_counter();
    }

    function increment_unread_count() {
        unread_count++;
        update_unread_counter();
    }

    function select_item(index) {
        var container = $('#item_container');

        // de-select current item
        container.find('.item-opened').removeClass('item-opened').addClass('item-closed');

        // select new item
        var item = container.children().eq(index);
        if (item.length == 0) {
            return;
        }
        item.removeClass('item-closed').addClass('item-opened');

        selected_item_index = index;

        scroll_to_item(index);

        var item_id = element_id_to_item_id(item.attr('id'));
        build_action_panel(item_id);

        // mark item as read
        // unless the user has previously kept the item unread
        if (item.data('kept-unread') != true && item.data('state') == 'unread') {
            var promise = API.mark_read(item_id);

            promise.success(function(data) {
                update_item_state(item_id, 'read');
            });
        }
    }

    function scroll_to_item(index) {
        var container = $('html,body');
        var item = $('#item_container').children().eq(index);

        // handle offset on small screens
        // when sidebar is across the top of the page
        var topbar_offset = $(window).width() < 992 ? $('#sidebar').height() : 0;

        container.scrollTop(item.offset().top - container.offset().top - topbar_offset);
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
        // don't refresh items twice at once
        if (is_refreshing) {
            return;
        }

        // disable refresh button
        is_refreshing = true;

        // begin animation
        $('#refresh-button .glyphicon-refresh').addClass('refresh-animation');

        var container = $('#item_container');
        container.empty();

        $.when(API.get_next_unread_items()).then(function(data) {
            data.items.forEach(function(item) {
                var content = $(format_item(item));
                container.append(content);
                content.find('.item-head').on('click', function(event) {
                    select_item_by_id(item.id);
                });
            });

            // update the number of unread items
            unread_count = data.items.length;

            select_item(0);

            // enable refresh button
            is_refreshing = false;

            // stop animation
            $('#refresh-button .glyphicon-refresh').removeClass('refresh-animation');
        });
    };

    ui.select_previous = function(e) {
        if (selected_item_index <= 0) {
            return;
        }

        select_item(selected_item_index - 1);
        
        if (e) {
            e.stopPropagation();
        }
    }
    
    ui.select_next = function(e) {
        if (selected_item_index + 1 >= $('#item_container').children().length) {
            return;
        }

        select_item(selected_item_index + 1);
        
        if (e) {
            e.stopPropagation();
        }
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

    ui.open_item_in_background = function() {
        var item = selected_item();
        var link = item.find('.item-link a').get(0);

        // simulate a control-click
        var click_event = document.createEvent('MouseEvents');
        click_event.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, true, false, false, false, 0, null);
        link.dispatchEvent(click_event);
    };

    function toggle_star(item_state, item_id) {
        var promise;
        if (item_state == 'starred') {
            promise = API.mark_read(item_id);
        } else {
            promise = API.star(item_id);
        }

        promise.success(function(data) {
            var new_state = item_state == 'starred' ? 'read' : 'starred';
            update_item_state(item_id, new_state);
        });
    }

    ui.toggle_starred = function() {
        var item       = selected_item();
        var item_id    = element_id_to_item_id(item.attr('id'));
        var item_state = item.data('state');

        toggle_star(item_state, item_id);
    };

    return ui;
}($));
