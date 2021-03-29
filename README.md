## 🖥　Multi-0-Design アプリケーション概要

- 名称：**Multi-0-Design**（まるちでざいん）
- 本番環境 URL：[Multi-0-Design | Amazon Web Services](http://multi-0-design.work)
  - 旧環境 URL：[Multi-0-Design | Heroku](https://multi-0-design.herokuapp.com)

###### 詳しくは、以下をご覧ください 🙇🏻‍♂️

<a href='https://qiita.com/Hirano_Tech/private/43ebab1548b133266a4d'><img src='https://user-images.githubusercontent.com/63486456/112334205-9c7dbd00-8cfe-11eb-9579-ab43d86031c3.png' width='30%' /></a>  
※ [本サービス（Multi-0-Design）解説](https://qiita.com/Hirano_Tech/private/43ebab1548b133266a4d) | Qiita

### ⚙️　開発環境，技術

- [**Ruby**](https://www.ruby-lang.org) Version 3.0
  - [Ruby | Docker Hub](https://hub.docker.com/layers/ruby/library/ruby/3.0.0/images/sha256-b7d6187e83a013c47667a126c45d15e3ee3ba84d175ea4d405e5b2b924e41799)
- [**Ruby on Rails**](https://rubyonrails.org) Version 6.1
  - [Ruby on Rails | Ruby Gems](https://rubygems.org/gems/rails)
- [**MySQL**](https://www.mysql.com/jp) Version 8.0
  - [MySQL | Docker Hub](https://hub.docker.com/layers/mysql/library/mysql/8.0.23/images/sha256-d5ba356f580dce71bebfc9fb0cd29b446cfb3aedff699fa9a1e34c2ffc88dd13)

- [**Git**](https://git-scm.com) Version 2.31
  - [Git | Homebrew](https://formulae.brew.sh/formula/git)
- [**Docker**](https://www.docker.com) Version 20.10
- **Docker-Compose** Version 1.28

- [**Amazon Web Services**](https://aws.amazon.com)
  - [**V**irtual **P**rivate **C**loud](https://aws.amazon.com/vpc)
  - [**E**lastic **C**ompute **C**loud](https://aws.amazon.com/ec2)
    - データベースサーバは、EC2 の中に導入しています。
  - [**Route 53**](https://aws.amazon.com/route53)

### 💿　データベース設計

##### ● users テーブル

|   Field    |     Type     | Null | Key | Default |     Extra      |
|------------|--------------|------|-----|---------|----------------| 
|     id     | int unsigned |  NO  | PRI |  NULL   | auto_increment |
|   email    | varchar(255) |  NO  | UNI |  NULL   |
|  password  | varchar(255) |  NO  |     |  NULL   |
| last_login |   datetime   |  NO  |     |  NULL   |
| ip_address | varchar(255) |  NO  |     |  NULL   |
| created_at |   datetime   |  NO  |     |  NULL   |

### 👥 ユーザー管理機能

##### ● 新規登録をおこなう際の処理の流れ

```Ruby
def create
  User.new(email: '値', password: '値')
    # 新規登録フォームに入力された値でインスタンスを作成する。

  =begin
    ● 新規登録フォームの入力内容が正しいかどうか検証する。
      ○ メールアドレス，パスワードが未入力ではないか。
      ○ メールアドレスは正しく入力されているか。
      ○ パスワードは 8文字以上である。
      ○ パスワード（確認用）は一致しているか。
  =end

  require 'mysql2'
  Mysql2::Client.new(host: :'値', username: :'値', password: ENV['値'], database: :'値').query(%{INSERT INTO 'テーブル名' ('カラム名') VALUES ('値';})
    # MySQL のデータベースに接続する。

  =begin
    ● データベースに登録される内容は以下のとおりです。
      ○ 新規登録フォームに入力したメールアドレス（小文字）
      ○ パスワードは、"HEX(AES_ENCRYPT('パスワード', '#{ENV['値']}'))" にて、暗号化して保存しています。
      ○ "#{request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip}" にて、IPアドレスを取得しています。
      ○ アカウント作成日 と 最終ログイン日として、現在日時を保存しています。
  =end

  rescue Mysql2::Error => e
    # メールアドレスに一意性制約を施しているため、エラーが発生すると新規登録フォームに戻ります。
    if e.message.include?('users.index_users_on_email')
      error << 'エラーメッセージ'
    end
  end

  # 最後に、ログインした状態でトップページに進みます。
end
```

##### ● 既存ユーザーのログインをするための処理の流れ

```Ruby
def create
  user = User.new(email: '値', password: '値')
    # ログインフォームで入力された値で User モデルのインスタンスを生成する。

  user_db = User.find_by_sql("SELECT id, email, CONVERT(AES_DECRYPT(UNHEX(password), '値') USING utf8mb4) FROM users WHERE email = '#{user.email}';")[0]
    # データベースから、入力されたメールアドレスと一致するレコードを取得し、インスタンスを生成する。
    # ログインをする際に必要であるカラムのみを取得する。

  if user_db == nil || user.password != user_db.password
    # データベースからレコードを取得できないとき、またはパスワードが一致しないときにエラーメッセージを返す。
  elsif user.password == user_db.password
    # ログインフォームで入力されたパスワードとデータベースから取得したパスワードが一致するときに、ログインさせる。

  require 'mysql2'
    Mysql2::Client.new(host: :'値', username: :'値', password: ENV['値'], database: :'値').query(%{INSERT INTO 'テーブル名' ('カラム名') VALUES ('値';})
      # MySQL のデータベースに接続する。

    %{UPDATE 'テーブル名' SET 'カラム名' = "#{Time.zone.now.strftime('%Y-%m-%d %H:%m:%S')}", 'カラム名' = "#{request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip}" WHERE id = #{user_db.id};}
      # セッションに主キーを保持させた後、最終ログイン日 と IPアドレスを更新する。
  end
end
```

- [MySQL に接続する処理をおこなうためのコントローラ（application_controller.rb）](app/controllers/application_controller.rb)

- [ユーザー管理機能をおこなうコントローラ（accounts_controller.rb）](app/controllers/accounts_controller.rb)

- [ログイン，ログアウトをおこなうコントローラ（sessions_controller.rb）](app/controllers/sessions_controller.rb)

---

### 🤷🏻‍♂️❓　遭遇したエラー履歴

<a href='https://qiita.com/Hirano_Tech/items/86349370f4d2cd5b437e'><img src='https://user-images.githubusercontent.com/63486456/112334205-9c7dbd00-8cfe-11eb-9579-ab43d86031c3.png' width='30%' /></a>  
※ [私が遭遇したエラー アーカイブ](https://qiita.com/Hirano_Tech/items/86349370f4d2cd5b437e) | Qiita

---

## 👤 開発者プロフィール

<a href='https://www.wantedly.com/id/Hirano_Tech'><img src='https://user-images.githubusercontent.com/63486456/112587247-9f80c680-8e40-11eb-86c2-aea8b2c41e4b.png' width='30%' /></a>

- [Wantedly プロフィール](https://www.wantedly.com/id/Hirano_Tech)
