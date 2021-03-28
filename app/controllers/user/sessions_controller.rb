class User::SessionsController < ApplicationController
  def new
    if session[:authenticity_token] != nil && session[:authenticity_token]['authenticity_token'].length == 86
      @user = User.find_by email: session[:authenticity_token]['email']
      session[:user_id] = @user.id
      session.delete(:authenticity_token)
      redirect_to root_path, notice: "You have successfully logged in."
    end
  end

  def create
    user = User.new(email: user_params['email'].downcase, password: user_params['password'])
    error = user.login_check

    if error == []
      user_db = User.find_by_sql("SELECT id, email, CONVERT(AES_DECRYPT(UNHEX(password), '#{ENV['SECRET_KEY_PASSWORD']}') USING utf8mb4) AS password FROM users WHERE email = '#{user.email}';")[0]

      if user_db == nil || user.password != user_db.password
        error << 'メールアドレス または パスワードが間違っています。'
        render action: :new, locals: { error: error }
      elsif user.password == user_db.password
        session[:user_id] = user_db.id

        client = mysql_connect
        today = "#{Time.zone.now.strftime('%Y-%m-%d %H:%m:%S')}"
        ip_address = "#{request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip}"
        sql = %{UPDATE users SET last_login = '#{today}', ip_address = '#{ip_address}' WHERE id = #{user_db.id};}
        client.query(sql)

        redirect_to root_path, notice: "You have successfully logged in."
      end
    else
      render action: :new, locals: { error: error }
    end
  end

  def show
    redirect_to new_user_sessions_path
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
