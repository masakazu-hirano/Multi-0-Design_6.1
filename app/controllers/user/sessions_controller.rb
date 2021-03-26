class User::SessionsController < ApplicationController
  def new
    if session[:authenticity_token]['authenticity_token'].nil?
    else
      @user = User.find_by email: session[:authenticity_token]['email'].downcase
      session[:user_id] = @user.id
      redirect_to root_path, notice: "You have successfully logged in."
    end
  end
end
