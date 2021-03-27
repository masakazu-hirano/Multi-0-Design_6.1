class User::AccountsController < ApplicationController
  def new
  end

  def create
    user = User.new(email: user_params['email'], password: user_params['password'])
    user.regist_check

    if @error.nil?
      if user_params['password'] != user_params['password_confirmation']
        @error << '入力されたパスワードが一致しません。'
        render action: :new
      end

      begin
        client = mysql_connect

        today = "#{Time.now.strftime('%Y-%m-%d %H:%m:%S')}"
        sql = %{INSERT INTO users (email, password, created_at) VALUES ('#{user_params['email'].downcase}', #{user.encrypt_password}, '#{today}');}

        client.query(sql)
        session[:authenticity_token] = {authenticity_token: user_params['authenticity_token'], email: user_params['email']}
        redirect_to  new_user_sessions_path

      rescue Mysql2::Error => e
        if e.message.include?('users.index_users_on_email')
          @error << 'このメールアドレスは、既に登録されています。'
          render action: :new
        end
      end
    else
      render action: :new
    end
  end

  private
  def user_params
    params.permit(:authenticity_token, :email, :password, :password_confirmation)
  end
end
