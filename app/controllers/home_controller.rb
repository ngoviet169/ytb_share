class HomeController < ApplicationController
  before_action :require_login, only: [:like_video, :dislike_video]
  before_action :check_video_react, only: [:like_video, :dislike_video]

  PER_PAGE = 5

  def index
    @videos = Video.includes(:user, :video_reacts).page(params[:page]).per(PER_PAGE)
    @search_value = params[:search_value]

    if @search_value.present?
      @videos = @videos.search_by_title_and_desc(@search_value)
    end
  end

  def like_video
    handle_video_react(VideoReact::LIKE_ACTION)
  end

  def dislike_video
    handle_video_react(VideoReact::DISLIKE_ACTION)
  end

  private

  def require_login
    render json: {status: false, message: "You must login first!"} unless logged_in?
  end

  def handle_video_react(action)
    if @video_react.nil?
      VideoReact.create(create_video_react_params.merge(react: action))
    else
      if @video_react.react == action.positive?
        @video_react.delete
      else
        @video_react.update(react: action)
      end
    end
    video = Video.find(params[:video_id])

    render json: {
      status: true,
      video: {
        total_like: video.total_like,
        total_dislike: video.total_dislike,
        is_reacted: video.reacted?(current_user),
        is_liked: video.liked?(current_user),
        is_disliked: video.disliked?(current_user),
      }
    }
  end

  def check_video_react
    @video_react = VideoReact.find_by(video_id: params[:video_id], user_id: current_user.id)
  end

  def create_video_react_params
    {
      video_id: params[:video_id],
      user_id: current_user.id,
    }
  end
end
