class CreateYoutubeVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :youtube_videos do |t|
      t.string :channel, presence: true
      t.string :video_id, presence: true, uniqueness: true
      t.string :title, presence: true
      t.binary :thumbnail, presence: true
      t.date :release_date, presence: true
      t.timestamps

      create_table :videos_users, id: false do |t|
        t.belongs_to :youtube_video
        t.belongs_to :user
      end
    end
  end
end
