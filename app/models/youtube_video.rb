class YoutubeVideo < ApplicationRecord
  validates :channel, :video_id, :title, :thumbnail, :release_date, presence: true
  validates :video_id, uniqueness: true

  has_many :users, through: :like_videos
end
