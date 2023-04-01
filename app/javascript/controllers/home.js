import { Application } from "@hotwired/stimulus"

const home = Application.start();

$(".like, .dislike, .liked, .disliked").on('click', function(e) {
    e.preventDefault();

    let className = 'display-none';
    let action = $(this).parents('.action');
    let url = action.find('.react-video-url').val();

    $.ajax({
        type: "GET",
        url: url,
        success: function(data)
        {
            if(data.status) {
                if(data.video.is_reacted) {
                    if(data.video.is_liked) {
                        hideButtonLike(action);
                        showButtonDislike(action);
                    } else {
                        hideButtonDislike(action);
                        showButtonLike(action);
                    }
                } else {
                    showButtonLike(action);
                    showButtonDislike(action);
                }
                action.parents('.react').find('.total-like').html(data.video.total_like);
                action.parents('.react').find('.total-dislike').html(data.video.total_dislike);
            } else {
                alert(data.message);
            }

        }
    });

});

function hideButtonDislike(action) {
    action.parents('.video-item').find('.dislike').addClass('display-none');
    action.parents('.video-item').find('.disliked').removeClass('display-none');
}

function showButtonDislike(action) {
    action.parents('.video-item').find('.dislike').removeClass('display-none');
    action.parents('.video-item').find('.disliked').addClass('display-none');
}

function hideButtonLike(action) {
    action.parents('.video-item').find('.like').addClass('display-none');
    action.parents('.video-item').find('.liked').removeClass('display-none');
}

function showButtonLike(action) {
    action.parents('.video-item').find('.like').removeClass('display-none');
    action.parents('.video-item').find('.liked').addClass('display-none');
}

export { home }
