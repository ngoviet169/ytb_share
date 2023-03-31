require 'rails_helper'

RSpec.describe VideoReact, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:video) { FactoryBot.create(:video, user_id: user.id) }

  it "is valid with valid attributes" do
    video_react = VideoReact.new(
      video_id: video.id,
      user_id: user.id,
      react: false
    )
    expect(video_react).to be_valid
  end

  it "is not valid without a video_id" do
    video_react = VideoReact.new(
      user_id: user.id,
      react: false
      )
    expect(video_react).to be_invalid
  end

  it "is not valid without a user_id" do
    video_react = VideoReact.new(
      video_id: video.id,
      react: false
      )
    expect(video_react).to be_invalid
  end

  it "react default false" do
    video_react = VideoReact.new(
      video_id: video.id,
      user_id: user.id
      )
    expect(video_react.react).to eq(false)
  end
end
