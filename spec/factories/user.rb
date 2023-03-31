FactoryBot.define do
  factory :user, class: 'User' do
    email { 'admin@mail.com' }
    password { '12345678' }
  end
end