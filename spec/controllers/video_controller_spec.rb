require 'rails_helper'

RSpec.describe VideosController, type: :controller do
  render_views
  let(:user) { FactoryBot.create(:user, email: 'user@test.com' ) }

  before do
    login(user)
  end

  describe 'GET #new' do
    before do
      get :new, format: "text/plain"
    end

    it 'http status 200' do
      expect(response).to have_http_status(200)
    end

    it "should render the new video template" do
      response.should render_template("new")
    end
  end

  describe 'POST #create' do
    context "create video success" do
      let(:request_param) {{
        title: 'video title',
        ytb_video_id: 'https://www.youtube.com/watch?v=video-id',
        description: 'description'
      }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 302 redirect' do
        expect(response).to have_http_status(302)
      end

      it 'create video success' do
        video = Video.last
        expect(video.title).to eq('video title')
        expect(video.description).to eq('description')
        expect(video.ytb_video_id).to eq('video-id')
      end
    end

    context "create video fail without title" do
      let(:request_param) {{
        ytb_video_id: 'https://www.youtube.com/watch?v=video-id',
        description: 'description'
      }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 200 redirect' do
        expect(response).to have_http_status(200)
      end

      it 'create video fail' do
        video = Video.last
        expect(video).to eq nil
      end
    end

    context "create video fail without video url" do
      let(:request_param) {{
        title: 'video title',
        description: 'description'
      }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 200 redirect' do
        expect(response).to have_http_status(200)
      end

      it 'create video fail' do
        video = Video.last
        expect(video).to eq nil
      end
    end

    context "create video fail without description" do
      let(:request_param) {{
        title: 'video title',
        ytb_video_id: 'https://www.youtube.com/watch?v=video-id'
      }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 200 redirect' do
        expect(response).to have_http_status(200)
      end

      it 'create video fail' do
        video = Video.last
        expect(video).to eq nil
      end
    end

    context "create video fail if title too long" do
      let(:request_param) {{
        title: 'video title' * 10,
        ytb_video_id: 'https://www.youtube.com/watch?v=video-id',
        description: 'description'
      }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 200 redirect' do
        expect(response).to have_http_status(200)
      end

      it 'create video fail' do
        video = Video.last
        expect(video).to eq nil
      end
    end

    context "create video fail if description too long" do
      let(:request_param) {{
        title: 'video title',
        ytb_video_id: 'https://www.youtube.com/watch?v=video-id',
        description: 'description' * 100
      }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 200 redirect' do
        expect(response).to have_http_status(200)
      end

      it 'create video fail' do
        video = Video.last
        expect(video).to eq nil
      end
    end

    context "create video fail if invalid video url" do
      let(:request_param) {{
        title: 'video title',
        ytb_video_id: "https://www.youtube.com/watch?v=#{'video-id' * 10}",
        description: 'description' * 100
      }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 200 redirect' do
        expect(response).to have_http_status(200)
      end

      it 'create video fail' do
        video = Video.last
        expect(video).to eq nil
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:video) { FactoryBot.create(:video, user_id: user.id) }
    let(:request_param) {{ id: video.id }}

    context "delete success" do
      before do
        delete :destroy, params: request_param, format: "text/plain"
      end

      it 'http status 200' do
        expect(response).to have_http_status(200)
      end

      it "delete video success" do
        result = JSON.parse(response.body)
        expect(result['status']).to eq true
      end
    end

    context "delete fail with invalid video id" do
      before do
        request_param[:id] = video.id + 999999
        delete :destroy, params: request_param, format: "text/plain"
      end

      it 'http status 200' do
        expect(response).to have_http_status(200)
      end

      it "delete video success" do
        result = JSON.parse(response.body)
        expect(result['status']).to eq false
        expect(result['message']).to eq('Video not found!')
      end
    end

    context "delete fail with not own video" do
      let(:user1) { FactoryBot.create(:user, email: 'user1@test.com' ) }
      let(:video) { FactoryBot.create(:video, user_id: (user1.id)) }
      before do
        request_param[:id] = video.id
        delete :destroy, params: request_param, format: "text/plain"
      end

      it 'http status 200' do
        expect(response).to have_http_status(200)
      end

      it "delete video success" do
        result = JSON.parse(response.body)
        expect(result['status']).to eq false
        expect(result['message']).to eq("You are not video's owner!")
      end
    end
  end

end