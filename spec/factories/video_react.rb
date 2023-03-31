FactoryBot.define do
  factory :video_react, class: 'VideoReact' do
    video_id { 1 }
    user_id { 1 }
    react { false }
  end
end