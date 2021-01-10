class InfluencersController < ApplicationController
  def index
    @welcome_time = Time.now.strftime('%H').to_i
  end
end
