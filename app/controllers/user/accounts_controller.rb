class User::AccountsController < ApplicationController
  def index
    redirect_to new_user_account_path
  end

  def new
  end

  def create
    user = User.new(email: user_params['email'], password: user_params['password'])
    error = user.regist_check

    if user.password != user_params['password_confirmation']
      error << '入力されたパスワードが一致しません。'
    end

    if error == []
      begin
        client = mysql_connect

        select_columns = 'email, password, last_login, ip_address, created_at'
        ip_address = "#{request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip}"
        sql = %{INSERT INTO users (#{select_columns}) VALUES (LOWER('#{user.email}'), #{user.encrypt_password}, NOW(), '#{ip_address}', NOW());}

        client.query(sql)
        session[:authenticity_token] = {authenticity_token: user_params['authenticity_token'], email: user.email}
        redirect_to new_user_sessions_path

      rescue Mysql2::Error => e
        if e.message.include?('users.index_users_on_email')
          error << 'このメールアドレスは、既に登録されています。'
          render action: :new, locals: { error: error }
        end
      end
    else
      render action: :new, locals: { error: error }
    end
  end

  def edit
  end

  private
  def user_params
    params.permit(:authenticity_token, :email, :password, :password_confirmation)
  end
end
