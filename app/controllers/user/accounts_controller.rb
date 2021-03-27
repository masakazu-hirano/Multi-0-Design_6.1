class User::AccountsController < ApplicationController
  def new
  end

  def create
    if user_params['email'] == ''
      flash[:email_blank] = '※ メールアドレスが未入力です ※'
      render action: :new
    elsif user_params['email'].include?('@') == false
      flash[:email_justice] = '※ メールアドレスを正しく入力してください ※'
      render action: :new
    elsif user_params['password'] == ''
      flash[:password_blank] = '※ パスワードが未入力です ※'
      render action: :new
    elsif user_params['password'].length < 8
      flash[:password_count] = '※ 8文字以上のパスワードを入力してください ※'
      render action: :new
    elsif user_params['password'] != user_params['password_confirmation']
      flash[:mismatch] = '※ 入力されたパスワードが一致しません ※'
      render action: :new
    else
      begin
        mysql_connect

        excrypt_password = "AES_ENCRYPT('#{user_params['password']}', '#{ENV['SECRET_KEY_PASSWORD']}')"
        string_excrypt_password = "HEX(#{excrypt_password})"
        today = "#{Time.now.strftime('%Y-%m-%d %H:%m:%S')}"

        sql = %{INSERT INTO users (email, password, created_at) VALUES ('#{user_params['email'].downcase}', #{string_excrypt_password}, '#{today}');}

        @client.query(sql)
        session[:authenticity_token] = {authenticity_token: user_params['authenticity_token'], email: user_params['email']}
        redirect_to  new_user_sessions_path

      rescue Mysql2::Error => e
        if e.message.include?('users.index_users_on_email')
          flash[:email_duplicate] = '※ このメールアドレスは、既に登録されています ※'
          render action: :new
        end
      end
    end
  end

  private
  def user_params
    params.permit(:authenticity_token, :email, :password, :password_confirmation)
  end
end
