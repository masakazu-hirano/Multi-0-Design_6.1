require 'rails_helper'

describe User do
  describe '#create' do
    it '必要な項目に正しく入力されている場合は新規登録ができること' do
      test_user = User.new(name: '匿名ユーザー', email: 'anonymous@example.com', password: '12345678', password_confirmation: '12345678', agreement: true)
      expect(test_user).to be_valid
    end

    it 'ユーザー名が未入力の場合は登録できないこと' do
      test_user = User.new(name: nil, email: 'anonymous@example.com', password: '12345678', password_confirmation: '12345678', agreement: true)
      test_user.valid?
      expect(test_user.errors[:name]).to include('を入力してください。')
    end

    it 'メールアドレスが未入力の場合は登録できないこと' do
      test_user = User.new(name: '匿名ユーザー', email: nil, password: '12345678', password_confirmation: '12345678', agreement: true)
      test_user.valid?
      expect(test_user.errors[:email]).to include('を入力してください。')
    end

    it '入力しているメールアドレスが既に登録されている場合は登録できないこと' do
      test_user = User.create(name: '匿名ユーザー', email: 'anonymous@example.com', password: '12345678', password_confirmation: '12345678', agreement: true)
      test_user_02 = User.new(name: 'テストユーザー', email: 'anonymous@example.com', password: '12345678', password_confirmation: '12345678', agreement: true)
      test_user_02.valid?
      expect(test_user_02.errors[:email]).to include('は既に登録されています。')
    end

    it 'パスワードが未入力の場合は登録できないこと' do
      test_user = User.new(name: '匿名ユーザー', email: 'anonymous@example.com', password: nil, password_confirmation: nil, agreement: true)
      test_user.valid?
      expect(test_user.errors[:password]).to include('を入力してください。')
    end

    it 'パスワードが 7文字以下の場合は登録できないこと' do
      test_user = User.new(name: '匿名ユーザー', email: 'anonymous@example.com', password: '1234567', password_confirmation: '1234567', agreement: true)
      test_user.valid?
      expect(test_user.errors[:password]).to include('は 8文字以上で入力してください。')
    end

    it '確認用のパスワードが一致しない場合は登録できないこと' do
      test_user = User.new(name: '匿名ユーザー', email: 'anonymous@example.com', password: '12345678', password_confirmation: '123456789', agreement: true)
      test_user.valid?
      expect(test_user.errors[:password_confirmation]).to include('とパスワードの入力が一致しません。')
    end

    it '利用規約に同意していない場合は登録できないこと' do
      test_user = User.new(name: '匿名ユーザー', email: 'anonymous@example.com', password: '12345678', password_confirmation: '12345678', agreement: false)
      test_user.valid?
      expect(test_user.errors[:agreement]).to include('に同意してください。')
    end
  end
end
