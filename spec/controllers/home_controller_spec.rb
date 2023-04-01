require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views
  let(:user) { FactoryBot.create(:user, email: 'user@test.com' ) }
  let!(:video) { FactoryBot.create(:video, user_id: user.id) }

  before do
    login(user)
  end

  describe 'GET #index' do
    let!(:video_2) { FactoryBot.create(:video, user_id: user.id, ytb_video_id: 'id-1') }
    let!(:video_3) { FactoryBot.create(:video, user_id: user.id, ytb_video_id: 'id-2') }

    before do
      get :index, format: "text/plain"
    end

    it 'http status 200' do
      expect(response).to have_http_status(200)
    end

    it "should render the home index template" do
      response.should render_template("index")
    end

    it 'total video is 3' do
      videos = Video.all
      expect(videos.count).to eq(3)
    end
  end

  describe 'GET #like_video' do
    let(:request_param) {{ video_id: video.id }}
    before do
      get :like_video, params: request_param, format: "text/plain"
    end

    it 'http status 302 redirect' do
      expect(response).to have_http_status(302)
    end

    it 'create video_reacts' do
      video_react = VideoReact.find_by(video_id: video.id, user_id: user.id)
      expect(video_react.video_id).to eq(video.id)
      expect(video_react.user_id).to eq(user.id)
      expect(video_react.react).to eq(true)
    end
  end

  describe 'GET #dislike_video' do
    let(:request_param) {{ video_id: video.id }}
    before do
      get :dislike_video, params: request_param, format: "text/plain"
    end

    it 'http status 302 redirect' do
      expect(response).to have_http_status(302)
    end

    it 'create video_reacts' do
      video_react = VideoReact.find_by(video_id: video.id, user_id: user.id)
      expect(video_react.video_id).to eq(video.id)
      expect(video_react.user_id).to eq(user.id)
      expect(video_react.react).to eq(false)
    end
  end

end