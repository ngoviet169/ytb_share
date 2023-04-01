import { Application } from "@hotwired/stimulus"

const home = Application.start();

$(".like, .dislike, .liked, .disliked").on('click', function(e) {
    e.preventDefault();

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

$('.btn-delete-video').on('click', function () {
    if(confirm('Are you sure want to delete this video?')) {
        let url = $(this).parent().find('.delete-video-url').val();
        let video_item = $(this).parents('.video-item');

        $.ajax({
            type: "DELETE",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
            url: url,
            success: function(data)
            {
                if(data.status) {
                    video_item.hide();
                } else {
                    if(data.message !== undefined) {
                        alert(data.message);
                    } else {
                        alert('Something went wrong!');
                    }
                }

            }
        });
    }
})

function hideButtonDislike(action) {
    action.parents('.video-item').find('.dislike').hide();
    action.parents('.video-item').find('.disliked').show();
}

function showButtonDislike(action) {
    action.parents('.video-item').find('.dislike').show();
    action.parents('.video-item').find('.disliked').hide();
}

function hideButtonLike(action) {
    action.parents('.video-item').find('.like').hide();
    action.parents('.video-item').find('.liked').show();
}

function showButtonLike(action) {
    action.parents('.video-item').find('.like').show();
    action.parents('.video-item').find('.liked').hide();
}

export { home }
