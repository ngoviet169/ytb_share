require 'rails_helper'

RSpec.describe Video, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it "is valid with valid attributes" do
    video = Video.new(
      title: 'title',
      description: 'description',
      ytb_video_id: 'xxx',
      user_id: user.id
    )
    expect(video).to be_valid
  end

  it "is not valid without a title" do
    video = Video.new(
      description: 'description',
      ytb_video_id: 'xxx',
      user_id: user.id
    )
    expect(video).to be_invalid
  end

  it "is not valid without a description" do
    video = Video.new(
      title: 'title',
      ytb_video_id: 'xxx',
      user_id: user.id
    )
    expect(video).to be_invalid
  end

  it "is not valid without a ytb_video_id" do
    video = Video.new(
      title: 'title',
      description: 'description',
      user_id: user.id
    )
    expect(video).to be_invalid
  end

  it "is not valid without a user_id" do
    video = Video.new(
      title: 'title',
      description: 'description',
      ytb_video_id: 'xxx'
    )
    expect(video).to be_invalid
  end

  it "total_like valid" do
    video = FactoryBot.create(:video, user_id: user.id)
    (1..10).each do |i|
      user = FactoryBot.create(:user, email: "admin#{i}@mail.com")
      FactoryBot.create(:video_react, user_id: user.id, video_id: video.id, react: VideoReact::LIKE_ACTION)
    end

    expect(video.total_like).to eq(10)
  end

  it "total_dislike valid" do
    video = FactoryBot.create(:video, user_id: user.id)
    (1..10).each do |i|
      user = FactoryBot.create(:user, email: "admin#{i}@mail.com")
      FactoryBot.create(:video_react, user_id: user.id, video_id: video.id, react: VideoReact::DISLIKE_ACTION)
    end

    expect(video.total_dislike).to eq(10)
  end

  it "user liked? is true" do
    video = FactoryBot.create(:video, user_id: user.id)
    FactoryBot.create(:video_react, user_id: user.id, video_id: video.id, react: VideoReact::LIKE_ACTION)

    expect(video.liked?(user)).to eq(true)
  end

  it "user liked? is false" do
    video = FactoryBot.create(:video, user_id: user.id)

    expect(video.liked?(user)).to eq(false)
  end

  it "user disliked? is true" do
    video = FactoryBot.create(:video, user_id: user.id)
    FactoryBot.create(:video_react, user_id: user.id, video_id: video.id, react: VideoReact::DISLIKE_ACTION)

    expect(video.disliked?(user)).to eq(true)
  end

  it "user disliked? is false" do
    video = FactoryBot.create(:video, user_id: user.id)

    expect(video.disliked?(user)).to eq(false)
  end

  it "user reacted? is true" do
    video = FactoryBot.create(:video, user_id: user.id)
    FactoryBot.create(:video_react, user_id: user.id, video_id: video.id, react: VideoReact::DISLIKE_ACTION)

    expect(video.reacted?(user)).to eq(true)
  end

  it "user reacted? is false" do
    video = FactoryBot.create(:video, user_id: user.id)

    expect(video.reacted?(user)).to eq(false)
  end
end
