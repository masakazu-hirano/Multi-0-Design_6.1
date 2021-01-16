class InfluencersController < ApplicationController
  def index
    @welcome_time = Time.now.strftime('%H').to_i
    @video_likes = YoutubeVideo.includes(:like_videos).sort {|a,b| b.like_videos.size <=> a.like_videos.size}
  end
end
