class VideoLikesController < ApplicationController
  before_action :authenticate_user!

  def create
    if YoutubeVideo.where(video_id: params[:video_id]).exists?
      video = YoutubeVideo.find_by video_id: params[:video_id]
      LikeVideo.create(youtube_video_id: video.id, user_id: current_user.id)
    else
      YoutubeVideo.create(channel: params[:channel], video_id: params[:video_id], title: params[:title], thumbnail: params[:thumbnail], release_date: Date.parse(params[:release_date]))

      video = YoutubeVideo.find_by video_id: params[:video_id]
      LikeVideo.create(youtube_video_id: video.id, user_id: current_user.id)
    end

    redirect_to youtube_videos_path
  end

  def destroy
    LikeVideo.find(params[:id]).destroy
    redirect_to youtube_videos_path
  end
end
