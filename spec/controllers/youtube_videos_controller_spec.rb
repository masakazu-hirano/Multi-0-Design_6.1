require 'rails_helper'

describe YoutubeVideosController do
  describe 'GET #index' do
    it 'YouTube Data API を利用して、特定のキーワードにて動画検索ができている（サムネイル画像 URL が取得していることで確認しています）。' do
      word = 'UNIQLO'
      get :index, params: { search: word }
      expect(assigns(:thumbnail)).to include('https://i.ytimg.com/vi')
    end

    it 'index.html.erb にページ遷移する。' do
      get :index
      expect(response).to render_template :index
    end
  end
end
