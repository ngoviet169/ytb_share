FactoryBot.define do
  factory :video, class: 'Video' do
    title { 'title' }
    description { 'description' }
    ytb_video_id { 'xxx' }
    user_id { 1 }
  end
end