# app/controllers/api/comments_controller.rb

class Api::CommentsController < ApplicationController
    before_action :set_article
    before_action :set_comment, only: [:show, :update, :destroy]

    # GET /api/articles/:article_id/comments
    def index
        @comments = @article.comments
        render json: @comments
    end

    # GET /api/articles/:article_id/comments/:id
    def show
        render json: @comment
    end

    # POST /api/articles/:article_id/comments
    def create
        @comment = @article.comments.new(comment_params)

        if @comment.save
            render json: @comment, status: :created
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    # PUT /api/articles/:article_id/comments/:id
    def update
        if @comment.update(comment_params)
            render json: @comment
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    # DELETE /api/articles/:article_id/comments/:id
    def destroy
        @comment.destroy
        head :no_content
    end

    private

    def set_article
        @article = Article.find(params[:article_id])
    end

    def set_comment
        @comment = @article.comments.find(params[:id])
    end

    def comment_params
        params.require(:comment).permit(:content, :author_name)
    end
end
