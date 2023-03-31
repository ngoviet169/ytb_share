require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  let!(:user) { FactoryBot.create(:user, email: 'user@test.com' ) }

  describe 'GET #create' do
    context "login with exists user" do
      let(:request_param) {{ email: user.email, password: '12345678' }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 302 redirect' do
        expect(response).to have_http_status(302)
      end

      it 'session user_id is present' do
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "create new user" do
      let(:request_param) {{ email: 'new_user@mail.com', password: '12345678' }}

      before do
        post :create, params: request_param, format: "text/plain"
      end

      it 'http status 302 redirect' do
        expect(response).to have_http_status(302)
      end

      it 'create new user success' do
        user = User.find_by(email: 'new_user@mail.com')
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe 'GET #destroy' do
    before do
      login(user)
    end

    context "login with exists user" do
      before do
        post :destroy, format: "text/plain"
      end

      it 'http status 302 redirect' do
        expect(response).to have_http_status(302)
      end

      it 'session user_id is present' do
        expect(session[:user_id]).to eq(nil)
      end
    end
  end

end