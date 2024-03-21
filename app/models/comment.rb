class Comment < ApplicationRecord
  belongs_to :article
  validates :content, presence: true # 空のコメントは投稿できないようにするバリデーション

end
