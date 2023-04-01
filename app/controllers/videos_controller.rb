class VideosController < ApplicationController
  before_action :require_login

  def new
  end

  def create
    create_video_params = share_video_params.merge(
      user_id: current_user.id,
      ytb_video_id: get_ytb_video_id
    )
    @video = Video.new(create_video_params)
    if @video.valid?
      @video.save!

      redirect_to home_index_path
    else
      @errors = @video.errors
      render 'new'
    end
  end

  private

  def get_ytb_video_id
    return if params[:ytb_video_id].blank?

    video_url = params[:ytb_video_id].split('&').first
    video_url.split('?v=').last
  end

  def share_video_params
    params.permit(:title, :description)
  end
end
