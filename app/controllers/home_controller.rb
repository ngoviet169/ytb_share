class HomeController < ApplicationController
  before_action :require_login, only: [:like_video, :dislike_video]
  before_action :check_video_react, only: [:like_video, :dislike_video]
  def index
    @videos = Video.includes(:user, :video_reacts)
  end

  def like_video
    handle_video_react(VideoReact::LIKE_ACTION)

    redirect_to home_index_path
  end

  def dislike_video
    handle_video_react(VideoReact::DISLIKE_ACTION)

    redirect_to home_index_path
  end

  private

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
