class Video < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 250 }
  validates :ytb_video_id, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20, message: "Video url invalid" }
  validates :auth, presence: true

  belongs_to :user
  has_many :video_reacts, class_name: 'VideoReact', foreign_key: 'video_id'

  scope :search_by_title_and_desc, ->(keyword) {
    where("videos.title like ? or videos.description like ?",
          "%#{sanitize_sql_like(keyword)}%",
          "%#{sanitize_sql_like(keyword)}%"
    )
  }

  def video_url
    "https://www.youtube.com/embed/#{self.ytb_video_id}"
  end

  def auth
    self.user&.email
  end

  def total_like
    self.video_reacts.where(react: VideoReact::LIKE_ACTION).count
  end

  def total_dislike
    self.video_reacts.where(react: VideoReact::DISLIKE_ACTION).count
  end

  def liked? user
    self.video_reacts.where(user_id: user.id, react: VideoReact::LIKE_ACTION).present?
  end

  def disliked? user
    self.video_reacts.where(user_id: user.id, react: VideoReact::DISLIKE_ACTION).present?
  end

  def reacted? user
    self.video_reacts.where(user_id: user.id).present?
  end
end
