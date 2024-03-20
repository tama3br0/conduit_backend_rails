class Api::ArticlesController < ApplicationController

    # GET /api/articles
    def index
        @articles = Article.all.order(created_at: :desc).page(params[:page]).per(10)
        render json: @articles
    end

    # GET /api/articles/:id
    def show
        @article = Article.find(params[:id])
        render json: @article
    end

    # POST /api/articles
    def create
        @article = Article.new(article_params)
        if @article.save
            render json: @article, status: :created # 201 OKのステータスを返す
        else
            render json: @article.errors, status: :unprocessable_entity # 422のエラーコード　リクエストは来ているが、意味的に間違っているときに返すもの
        end
    end

    # PUT/PATCH  /api/articles/:id
    def update
         @article = Article.find(params[:id])
        if @article.update(article_params)
            render json: @article
        else
            render json: @article.errors, status: :unprocessable_entity
        end
    end

    # DELETE /api/articles/:id
    def destroy
        @article = Article.find(params[:id])
        @article.destroy
    end

    private

    def article_params
        params.require(:article).permit(:title, :description, :body, :image, tag_list: [])
    end
end
