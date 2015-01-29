$(document).ready(function() {
    UI.load_unread_items();
    $('button.previous-item-button').on('click', UI.select_previous);
    $('button.next-item-button').on('click', UI.select_next);
});

document.onkeydown = function(event) {
    switch (event.keyCode) {
        case 74: // j
            UI.select_next();
            break;
        case 75: // k
            UI.select_previous();
            break;
        case 32: // <space>
            if (event.shiftKey) {
                UI.select_previous();
            } else {
                UI.select_next();
            }
            event.preventDefault();
            break;
        case 82: // r
            UI.load_unread_items();
            break;
        case 83: // s
            UI.toggle_starred();
            break;
        case 86: // v
            UI.open_item_in_background();
            break;
        case 77: // m
            UI.toggle_read();
            break;
    }
};
