import { Application } from "@hotwired/stimulus"

const videos = Application.start();

$('#btn-close').on('click', function () {
    let error = $('#error');
    error.removeClass('show');
    error.addClass('hide');
})

export { videos }
