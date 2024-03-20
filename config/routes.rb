Rails.application.routes.draw do
    namespace :api do
        resources :articles, except: [:new, :edit]

        post '/upload_image', to: 'article_images#upload_image' # コントローラーとアクションの指定を追記

    end
end
