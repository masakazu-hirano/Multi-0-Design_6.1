class Users::RecruiterSessionsController < Devise::SessionsController
  def recruiter_login
    if Rails.env.development?
      user = User.find_by(email: Rails.application.credentials.Recruiter[:Mail_Address])
    elsif Rails.env.production?
      user = User.find_by(email: ENV['Recruiter_ID'])
    end

    sign_in user
    redirect_to root_path
  end
end
