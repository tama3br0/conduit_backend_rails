class Article < ApplicationRecord
    has_one_attached :image #=> 1つの投稿に1つの画像をアップロードすることが可能
end
