require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.create(:user) }

  it "is valid with valid attributes" do
    user = User.new(
      email: 'user@mail.com',
      password: 'password'
    )
    expect(user).to be_valid
  end

  it "invalid email" do
    user = User.new(
      email: 'email',
      password: 'password'
    )
    expect(user).to be_invalid
  end

  it "email is too long" do
    user = User.new(
      email: "user#{'x' * 100}@mail.com",
      password: 'password'
    )
    expect(user).to be_invalid
  end

  it "email is duplicated" do
    user = User.new(
      email: "admin@mail.com",
      password: 'password'
    )
    expect(user).to be_invalid
  end

  it "is not valid without a email" do
    user = User.new(
      password: 'password'
      )
    expect(user).to be_invalid
  end

  it "is not valid without a password" do
    user = User.new(
      email: 'user@mail.com'
    )
    expect(user).to be_invalid
  end
end
