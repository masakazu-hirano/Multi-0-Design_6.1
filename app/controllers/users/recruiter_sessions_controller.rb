class Users::RecruiterSessionsController < Devise::SessionsController
  def recruiter_login
    user = User.find_or_create_by!(email: Rails.application.credentials.Recruiter[:Mail_Address])
    sign_in user
    redirect_to root_path
  end
end
