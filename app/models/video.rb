class Video < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :video_id, presence: true
  validates :auth, presence: true

  belongs_to :user

  def video_url
    "https://www.youtube.com/embed/#{self.video_id}"
  end

  def auth
    self.user.email
  end
end
