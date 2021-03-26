class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

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
        require 'mysql2'
        client = Mysql2::Client.new(host: :'db', username: :'root', password: ENV['MYSQL_ROOT_PASSWORD'], database: :'Multi_0_Design_development')
        sql = %{INSERT INTO users (email, password, created_at) VALUES ('#{user_params['email']}', HEX(AES_ENCRYPT('#{user_params["password"]}', '#{ENV['SECRET_KEY_PASSWORD']}')), '#{Time.now.strftime('%Y-%m-%d %H:%m:%S')}');}

        client.query(sql)

        @user = User.find_by email: user_params['email']
        session[:user_id] = @user.id
        redirect_to root_path, notice: "You have successfully logged in."
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
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
