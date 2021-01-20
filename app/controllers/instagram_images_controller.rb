class InstagramImagesController < ApplicationController
  def index
    @welcome_time = Time.now.strftime('%H').to_i
  end

  def create
    # ↓ Instagram ハッシュタグ ノードID を取得する。 ↓
    if Rails.env.development?
      business_id = Rails.application.credentials.Instagram[:Business_ID]
      access_token = Rails.application.credentials.Instagram[:Access_Token]
    elsif Rails.env.production?
      business_id = ENV['Instagram_Business_ID']
      access_token = ENV['Instagram_Access_Token']
    end

    search_word = URI.encode_www_form(q: params[:search])
    tag_id_uri = URI.parse("https://graph.facebook.com/v9.0/ig_hashtag_search?user_id=#{business_id}&#{search_word}&access_token=#{access_token}")
    tag_id = JSON.parse(Net::HTTP.get_response(tag_id_uri).body)['data'][0]['id']

    # ↓ Instagram ハッシュタグ検索 ↓
    search_uri = URI.parse("https://graph.facebook.com/v9.0/#{tag_id}/top_media?user_id=#{business_id}&fields=media_type,media_url,children{media_url},like_count,permalink,timestamp&limit=#{params[:count].to_i}&access_token=#{access_token}")
    search_results = JSON.parse(Net::HTTP.get_response(search_uri).body)

    image_lists = []
    search_results['data'].each do |search_result|
      image_list = Hash.new

      if search_result['media_type'] == 'IMAGE'
        image_list[:media_type] = search_result['media_type']
        image_list[:media_url] = search_result['media_url']
        image_list[:like_count] = search_result['like_count']
        image_list[:permalink] = search_result['permalink']
        image_list[:timestamp] = search_result['timestamp']

        image_lists << image_list
      elsif search_result['media_type'] == 'CAROUSEL_ALBUM'
        image_list[:media_type] = search_result['media_type']
        image_list[:like_count] = search_result['like_count']
        image_list[:permalink] = search_result['permalink']
        image_list[:timestamp] = search_result['timestamp']

        album_images = []
        search_result['children']['data'].each do |album_image|
          album_images << album_image['media_url']
        end
        image_list[:album_images] = album_images

        image_lists << image_list
      end
    end

    Rails.cache.delete('instagram_images')
    Rails.cache.write('instagram_images', image_lists, expired_in: 1.hour, compress: true)

    render action: :index, locals: { image_lists: image_lists }
  end
end
