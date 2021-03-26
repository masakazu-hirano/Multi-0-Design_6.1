class User::SessionsController < ApplicationController
  def new
    if session[:authenticity_token] == nil
    else
      @user = User.find_by email: session[:authenticity_token]['email'].downcase
      session[:user_id] = @user.id
      session.delete(:authenticity_token)
      redirect_to root_path, notice: "You have successfully logged in."
    end
  end

  def create
    decrypt_password = "AES_DECRYPT(UNHEX(password), '#{ENV['SECRET_KEY_PASSWORD']}')"
    encode_password = "CONVERT(#{decrypt_password} USING utf8mb4)"
    user = User.find_by_sql("SELECT id, email, #{encode_password} AS password FROM users WHERE email = '#{user_params['email'].downcase}';")

    if user == []
      flash[:email_blank] = '※ メールアドレスが異なります ※'
      render action: :new
    else
      if user[0]['password'] == user_params['password']
        session[:user_id] = user[0]['id']
        redirect_to root_path, notice: "You have successfully logged in."
      else
        flash[:password_blank] = '※ パスワードが異なります ※'
        render action: :new
      end
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to  root_path
  end

  private
  def user_params
    params.permit(:authenticity_token, :email, :password)
  end
end
