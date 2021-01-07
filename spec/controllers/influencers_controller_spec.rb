require 'rails_helper'

describe InfluencersController do
  describe 'GET #index' do
    it 'index.html.erb にページ遷移する。' do
      get :index
      expect(response).to render_template :index
    end
  end
end
