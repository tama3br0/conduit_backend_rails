class Api::ArticleImagesController < ApplicationController
    def upload_image
      image = params[:image]
      article = Article.create(image: image) # Active Storageを使用して画像を保存し、Articleを作成

      render json: { image_url: url_for(article.image) } # 作成したArticleの画像のURLを返す
    end
end