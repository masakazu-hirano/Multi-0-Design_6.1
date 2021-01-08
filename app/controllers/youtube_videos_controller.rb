class YoutubeVideosController < ApplicationController
  def index
    require 'google/apis/youtube_v3'

    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.key = Rails.application.credentials.YouTube[:Data_API_Key]

    options = { q: params[:search] , order: 'relevance', max_results: 1 }
    video_lists = youtube.list_searches(:snippet, options).to_h

    @video_id = video_lists[:items][0][:id][:video_id]
    @title = video_lists[:items][0][:snippet][:title]
    @thumbnail = video_lists[:items][0][:snippet][:thumbnails][:high][:url]
    @release_date = video_lists[:items][0][:snippet][:published_at]
  end
end
