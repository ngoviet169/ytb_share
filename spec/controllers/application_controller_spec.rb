require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let!(:user) { FactoryBot.create(:user, email: 'user@test.com' ) }

  describe '#logged_in?' do
    controller do
      def index
        render json: { result: logged_in? }
      end
    end

    context "logged in is true" do
      before do
        login(user)
        get :index, format: :json
      end

      it 'logged_in is true' do
        result = JSON.parse(response.body)['result']
        expect(result).to eq(true)
      end
    end

    context "logged in is false" do
      before do
        get :index, format: :json
      end

      it 'logged_in is true' do
        result = JSON.parse(response.body)['result']
        expect(result).to eq(false)
      end
    end
  end

  describe '#current_user' do
    controller do
      def index
        render json: { result: current_user }
      end
    end

    context "is logged in" do
      before do
        login(user)
        get :index, format: :json
      end

      it 'logged_in is true' do
        result = JSON.parse(response.body)['result']
        expect(result['id']).to eq(user.id)
        expect(result['email']).to eq(user.email)
      end
    end

    context "logged in is false" do
      before do
        get :index, format: :json
      end

      it 'logged_in is true' do
        result = JSON.parse(response.body)['result']
        expect(result).to eq(nil)
      end
    end
  end

end