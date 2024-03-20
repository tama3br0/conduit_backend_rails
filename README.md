# README

## Rails API の手順

### 1. Rails を API モードで構築

```bash
rails new . --api -T -d mysql
```

-   API モードにすることで、view を生成せず、API に特化した状態で構築できる
-   テストフレームワークをスキップするために、「-T」
-   MySQL の設定を行う

    -   database.yml ファイルに追記
    -   パスワードを.env ファイルで管理
    -   Gemfile に gem 'dotenv-rails'を追記

-   Next.js をポート 3001 で開くので、その CORS 設定を行う
    -   Genfile にある gem "rack-cors"のコメントアウトを外す
    -   config/initializers/cors.rb のコメントアウトを外す
        -   origins "localhost:3001"と修正

### 2. Article モデルを生成

```bash
rails g model Article title:string description:string body:string

rails db:migrate
```

-   ブログ投稿に必要な内容をカラムに設定
-   画像も投稿するようにしたい場合は

```bash
railsrails active_storage:install

rails db:migrate
```

-   article.rb に追記

```rb:article.rb
class Article < ApplicationRecord
    has_one_attached :image #=> 1つの投稿に1つの画像をアップロードすることが可能
end
```

-   Conduit では、tagList も投稿で扱うようなので、カラムに追加

```bash
rails g migration AddTagListToArticles
```

```rb:マイグレーションファイル
class AddTagListToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :tag_list, :json,
  end
end
```

```bash
rails db:migrate
```

### 3. articles コントローラの生成

```bash
rails g controllers Api::articles
```

### 4. ルーターの設定

```rb:routes.rb
Rails.application.routes.draw do
    namespace :api do
        resources :articles, except: [:new, :edit]
    end
end
```

-   new と edit 以外のアクションを使うと設定

### 5. articles コントローラのアクションを作成

-   JSON 形式でデータを返すようにすることで、Next.js に渡すことができる。

-   ストロングパラメータは次のようになる

```rb:articles_controller.rb
    # 省略
    private

    def article_params
        params.require(:article).permit(:title, :description, :body, :image, tag_list: [])
    end
```

### 6. Postman を使って、API が上手く動いているか確かめる

-   POST localhost:3000/api/articles にポストして、返ってくるか確かめる

```json
{
    "article": {
        "title": "Postmanから投稿",
        "description": "このDIOが、貴様にジョジョ立ちを教えてやるッ！",
        "body": "さすがDIO。俺たちにできないことを平然とやってのける。そこにしびれるゥあこがれゥゥ！！",
        "tag_list": ["ジョジョ", "DIO", "あこがれ"]
    }
}
```

-   GET localhost:3000/api/articles で、投稿が取得できるか確かめる

```json
{
        "id": 1,
        "title": "Postmanから投稿",
        "description": "このDIOが、貴様にジョジョ立ちを教えてやるッ！",
        "body": "さすがDIO。俺たちにできないことを平然とやってのける。そこにしびれるゥあこがれゥゥ！！",
        "created_at": "2024-03-20T17:19:09.843Z",
        "updated_at": "2024-03-20T17:19:09.843Z",
        "tag_list": [
            "ジョジョ",
            "DIO",
            "あこがれ"
        ]
    },
```

-   同様にして、PATCH や DELETE も確かめることができる

### 7. 画像をアップロードするための準備を進める

-   コントローラを追加する

```bash
rails g controllers Api::ArticleImages
```

```rb:article_images_controller.rb
class Api::ArticleImagesController < ApplicationController
    def upload_image
      image = params[:image]
      article = Article.create(image: image) # Active Storageを使用して画像を保存し、Articleを作成

      render json: { image_url: url_for(article.image) } # 作成したArticleの画像のURLを返す
    end
end
```

-   ルーターを設定する

```rb:router.rb
Rails.application.routes.draw do
    namespace :api do
        resources :articles, except: [:new, :edit]

        post '/upload_image', to: 'article_images#upload_image' # コントローラーとアクションの指定を追記

    end
end
```
