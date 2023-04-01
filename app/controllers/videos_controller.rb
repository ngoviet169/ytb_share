class VideosController < ApplicationController
  before_action :require_login
  before_action :can_delete_video, only: [:destroy]

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

  def destroy
    if @video.delete
      return render json: { status: true}
    end

    render json: { status: false}
  end

  private

  def can_delete_video
    @video = Video.find_by(id: params[:id])

    return render json: { status: false, message: "Video not found!"} unless @video

    render json: { status: false, message: "You are not video's owner!" } unless @video.user_id.eql?(current_user.id)
  end

  def get_ytb_video_id
    return if params[:ytb_video_id].blank?

    video_url = params[:ytb_video_id].split('&').first
    video_url.split('?v=').last
  end

  def share_video_params
    params.permit(:title, :description)
  end
end
