Rails.application.routes.draw do
    namespace :api do
        resources :articles, except: [:new, :edit] do
            resources :comments, only: [:index, :create, :show, :update, :destroy]
            # GET /api/articles/:article_id/comments(.:format)   comments#index
            # POST /api/articles/:article_id/comments(.:format)  comments#create
            # GET /api/articles/:article_id/comments/:id(.:format) comments#show
            # PUT /api/articles/:article_id/comments/:id(.:format) comments#update
            # DELETE /api/articles/:article_id/comments/:id(.:format) comments#destroy
        end

        post '/upload_image', to: 'article_images#upload_image' # コントローラーとアクションの指定を追記
        get '/tags/popular', to: 'tags#popular' # 頻出tagを取得するためのAPI
    end
end
