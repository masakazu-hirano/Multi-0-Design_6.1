class YoutubeVideosController < ApplicationController
  def index
  end

  def create
    require 'google/apis/youtube_v3'
    youtube = Google::Apis::YoutubeV3::YouTubeService.new

    if Rails.env.development?
      youtube.key = Rails.application.credentials.YouTube[:Data_API_Key]
    elsif Rails.env.production?
      youtube.key = ENV['YouTube_API_Key']
    end

    options = { q: params[:search] , order: 'relevance', max_results: params[:count].to_i }
    youtube_videos = youtube.list_searches(:snippet, options).to_h

    if params[:count].to_i == 1
      video_lists = []

      video_list = Hash.new
        video_list[:video_id] = youtube_videos[:items][0][:id][:video_id]
        video_list[:title] = youtube_videos[:items][0][:snippet][:title]
        video_list[:channel] = youtube_videos[:items][0][:snippet][:channel_title]
        video_list[:thumbnail] = youtube_videos[:items][0][:snippet][:thumbnails][:high][:url]
        video_list[:release_date] = youtube_videos[:items][0][:snippet][:published_at]
      video_lists << video_list

    elsif params[:count].to_i == 3
      video_lists = []
      number = 1

      while number <= 3 do
        video_list = Hash.new
          video_list[:video_id] = youtube_videos[:items][number - 1][:id][:video_id]
          video_list[:title] = youtube_videos[:items][number - 1][:snippet][:title]
          video_list[:channel] = youtube_videos[:items][number - 1][:snippet][:channel_title]
          video_list[:thumbnail] = youtube_videos[:items][number - 1][:snippet][:thumbnails][:high][:url]
          video_list[:release_date] = youtube_videos[:items][number - 1][:snippet][:published_at]

        video_lists << video_list
        number += 1
      end

    elsif params[:count].to_i == 5
      video_lists = []
      number = 1

      while number <= 5 do
        video_list = Hash.new
          video_list[:video_id] = youtube_videos[:items][number - 1][:id][:video_id]
          video_list[:title] = youtube_videos[:items][number - 1][:snippet][:title]
          video_list[:channel] = youtube_videos[:items][number - 1][:snippet][:channel_title]
          video_list[:thumbnail] = youtube_videos[:items][number - 1][:snippet][:thumbnails][:high][:url]
          video_list[:release_date] = youtube_videos[:items][number - 1][:snippet][:published_at]

        video_lists << video_list
        number += 1
      end

    else
      redirect_to root_path
    end

    session[:video_lists] = video_lists
    render action: :index, locals: { video_lists: video_lists }
  end
end
