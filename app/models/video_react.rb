class VideoReact < ApplicationRecord
  belongs_to :user
  belongs_to :video, class_name: 'Video', foreign_key: 'video_id'

  LIKE_ACTION = 1
  DISLIKE_ACTION = 0
end
