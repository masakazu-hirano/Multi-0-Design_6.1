class YoutubeVideosController < ApplicationController
  def index
  end

  def new
    session[:video_search_count] = params[:count].to_i

    require 'google/apis/youtube_v3'
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    # youtube.key = Rails.application.credentials.YouTube[:Data_API_Key]
    youtube.key = ENV['YouTube_API_Key']
    options = { q: params[:search] , order: 'relevance', max_results: session[:video_search_count] }
    video_lists = youtube.list_searches(:snippet, options).to_h

    if params[:count].to_i == 1
      @video_lists_1 = Hash.new
      @video_lists_1[:video_id] = video_lists[:items][0][:id][:video_id]
      @video_lists_1[:title] = video_lists[:items][0][:snippet][:title]
      @video_lists_1[:channel] = video_lists[:items][0][:snippet][:channel_title]
      @video_lists_1[:thumbnail] = video_lists[:items][0][:snippet][:thumbnails][:high][:url]
      @video_lists_1[:release_date] = video_lists[:items][0][:snippet][:published_at]
      session[:video_lists_1] = @video_lists_1

    elsif params[:count].to_i == 3
      @video_lists_1 = Hash.new
      @video_lists_1[:video_id] = video_lists[:items][0][:id][:video_id]
      @video_lists_1[:title] = video_lists[:items][0][:snippet][:title]
      @video_lists_1[:channel] = video_lists[:items][0][:snippet][:channel_title]
      @video_lists_1[:thumbnail] = video_lists[:items][0][:snippet][:thumbnails][:high][:url]
      @video_lists_1[:release_date] = video_lists[:items][0][:snippet][:published_at]
      session[:video_lists_1] = @video_lists_1

      @video_lists_2 = Hash.new
      @video_lists_2[:video_id] = video_lists[:items][1][:id][:video_id]
      @video_lists_2[:title] = video_lists[:items][1][:snippet][:title]
      @video_lists_2[:channel] = video_lists[:items][1][:snippet][:channel_title]
      @video_lists_2[:thumbnail] = video_lists[:items][1][:snippet][:thumbnails][:high][:url]
      @video_lists_2[:release_date] = video_lists[:items][1][:snippet][:published_at]
      session[:video_lists_2] = @video_lists_2

      @video_lists_3 = Hash.new
      @video_lists_3[:video_id] = video_lists[:items][2][:id][:video_id]
      @video_lists_3[:title] = video_lists[:items][2][:snippet][:title]
      @video_lists_3[:channel] = video_lists[:items][2][:snippet][:channel_title]
      @video_lists_3[:thumbnail] = video_lists[:items][2][:snippet][:thumbnails][:high][:url]
      @video_lists_3[:release_date] = video_lists[:items][2][:snippet][:published_at]
      session[:video_lists_3] = @video_lists_3

    elsif params[:count].to_i == 5
      @video_lists_1 = Hash.new
      @video_lists_1[:video_id] = video_lists[:items][0][:id][:video_id]
      @video_lists_1[:title] = video_lists[:items][0][:snippet][:title]
      @video_lists_1[:channel] = video_lists[:items][0][:snippet][:channel_title]
      @video_lists_1[:thumbnail] = video_lists[:items][0][:snippet][:thumbnails][:high][:url]
      @video_lists_1[:release_date] = video_lists[:items][0][:snippet][:published_at]
      session[:video_lists_1] = @video_lists_1

      @video_lists_2 = Hash.new
      @video_lists_2[:video_id] = video_lists[:items][1][:id][:video_id]
      @video_lists_2[:title] = video_lists[:items][1][:snippet][:title]
      @video_lists_2[:channel] = video_lists[:items][1][:snippet][:channel_title]
      @video_lists_2[:thumbnail] = video_lists[:items][1][:snippet][:thumbnails][:high][:url]
      @video_lists_2[:release_date] = video_lists[:items][1][:snippet][:published_at]
      session[:video_lists_2] = @video_lists_2

      @video_lists_3 = Hash.new
      @video_lists_3[:video_id] = video_lists[:items][2][:id][:video_id]
      @video_lists_3[:title] = video_lists[:items][2][:snippet][:title]
      @video_lists_3[:channel] = video_lists[:items][2][:snippet][:channel_title]
      @video_lists_3[:thumbnail] = video_lists[:items][2][:snippet][:thumbnails][:high][:url]
      @video_lists_3[:release_date] = video_lists[:items][2][:snippet][:published_at]
      session[:video_lists_3] = @video_lists_3

      @video_lists_4 = Hash.new
      @video_lists_4[:video_id] = video_lists[:items][3][:id][:video_id]
      @video_lists_4[:title] = video_lists[:items][3][:snippet][:title]
      @video_lists_4[:channel] = video_lists[:items][3][:snippet][:channel_title]
      @video_lists_4[:thumbnail] = video_lists[:items][3][:snippet][:thumbnails][:high][:url]
      @video_lists_4[:release_date] = video_lists[:items][3][:snippet][:published_at]
      session[:video_lists_4] = @video_lists_4

      @video_lists_5 = Hash.new
      @video_lists_5[:video_id] = video_lists[:items][4][:id][:video_id]
      @video_lists_5[:title] = video_lists[:items][4][:snippet][:title]
      @video_lists_5[:channel] = video_lists[:items][4][:snippet][:channel_title]
      @video_lists_5[:thumbnail] = video_lists[:items][4][:snippet][:thumbnails][:high][:url]
      @video_lists_5[:release_date] = video_lists[:items][4][:snippet][:published_at]
      session[:video_lists_5] = @video_lists_5
    end

    redirect_to youtube_videos_path
  end
end
