class RootsController < ApplicationController
  def index
    unless session[:user_id].nil?
      @user = User.find_by_sql("SELECT id, email, last_login FROM users WHERE id = #{session[:user_id]};")[0]
    end
  end
end
