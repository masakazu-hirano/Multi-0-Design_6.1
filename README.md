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

---

### 👥 ユーザー管理機能

##### ● 新規登録をおこなう際の処理の流れ

```Ruby
def create
  if 'フォームに入力された内容の検証（バリデーションチェック）'
    # 'True' となる条件がある場合はエラーメッセージを表示して新規登録フォームに戻す。
  else
    begin
      client = Mysql2::Client.new()
        # MySQL のデータベースに接続する。
      sql = %{INSERT INTO 'テーブル名' ('カラム名') VALUES ('値')
        # パスワードは、'HEX(AES_ENCRYPT())' を実行して、AES_ENCRYPT() 関数で MySQL にて暗号化をおこない、HEX() 関数で文字列として保存する。
        # アカウント作成日は、'Time.now.strftime('%Y-%m-%d %H:%m:%S')}')' にて、日時を取得する。

      client.query(sql)
      @user = User.find_by email: user_params['email']
        # 正常にユーザー情報が登録されたら、フォームに入力されたメールアドレスから一致するレコードを取得する。
      session[:user_id] = @user.id
        # 取得したレコードの 'id' をセッションに保存して、ログイン状態にする。

    rescue Mysql2::Error => e
      # データベースにユーザー情報を登録する際に MySQL でエラーが出た場合…

      if e.message.include?('users.index_users_on_email')
        # 既にメールアドレスが登録されている場合の処理
  end
```

- [ユーザー管理機能をおこなうコントローラ（users_controller.rb）](app/controllers/users_controller.rb)

---

### 🤷🏻‍♂️❓　遭遇したエラー履歴

<a href='https://qiita.com/Hirano_Tech/items/86349370f4d2cd5b437e'><img src='https://user-images.githubusercontent.com/63486456/112334205-9c7dbd00-8cfe-11eb-9579-ab43d86031c3.png' width='30%' /></a>
※ [私が遭遇したエラー アーカイブ](https://qiita.com/Hirano_Tech/items/86349370f4d2cd5b437e) | Qiita

---

## 👤 開発者プロフィール

<a href='https://www.wantedly.com/id/Hirano_Tech'><img src='https://user-images.githubusercontent.com/63486456/112587247-9f80c680-8e40-11eb-86c2-aea8b2c41e4b.png' width='30%' /></a>

- [Wantedly プロフィール](https://www.wantedly.com/id/Hirano_Tech)
