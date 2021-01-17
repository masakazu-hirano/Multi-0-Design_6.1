class CreateLikeVideos < ActiveRecord::Migration[6.1]
  def up
    create_table :like_videos do |t|
      t.references :user, foreign_key: true
      t.references :youtube_video, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :like_videos
  end
end
