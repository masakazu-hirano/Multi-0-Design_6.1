class CreateYoutubeVideos < ActiveRecord::Migration[6.1]
  def up
    create_table :youtube_videos do |t|
      t.string :channel, null: false
      t.string :video_id, null: false
      t.string :title, null: false
      t.binary :thumbnail, null: false
      t.date :release_date, null: false
      t.timestamps
    end

    add_index :youtube_videos, :video_id, unique: true
  end

  def down
    drop_table :youtube_videos
  end
end
