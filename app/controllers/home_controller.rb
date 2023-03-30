class HomeController < ApplicationController
  before_action :require_login, only: [:like_video, :dislike_video]
  before_action :check_video_react, only: [:like_video, :dislike_video]
  def index
    @videos = Video.includes(:user, :video_reacts)
  end

  def like_video
    if @video_react.nil?
      VideoReact.create(video_react_params.merge(react: VideoReact::LIKE_ACTION))
    else
      toggle_or_delete(VideoReact::LIKE_ACTION)
    end

    redirect_to home_index_path
  end

  def dislike_video
    if @video_react.nil?
      VideoReact.create(video_react_params.merge(react: VideoReact::DISLIKE_ACTION))
    else
      toggle_or_delete(VideoReact::DISLIKE_ACTION)
    end

    redirect_to home_index_path
  end

  private

  def toggle_or_delete(action)
    if @video_react.react == action.positive?
      @video_react.delete
    else
      @video_react.update(react: action)
    end
  end

  def check_video_react
    @video_react = VideoReact.find_by(video_id: params[:video_id], user_id: current_user.id)
  end

  def video_react_params
    {
      video_id: params[:video_id],
      user_id: current_user.id,
    }
  end
end
