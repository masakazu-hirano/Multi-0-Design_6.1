class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true

  def regist_check
    @error = Array.new

      if self.email == ''
        @error << 'メールアドレスが未入力です。'
      elsif self.email.include?('@') == false
        @error << 'メールアドレスを正しく入力してください。'
      end

      if self.password == ''
        @error << 'パスワードが未入力です'
      elsif self.password.length < 8
        @error << 'パスワードを 8文字以上で入力してください。'
      end

    return @error
  end

  def encrypt_password
    return "HEX(AES_ENCRYPT('#{self.password}', '#{ENV['SECRET_KEY_PASSWORD']}'))"
  end
end
