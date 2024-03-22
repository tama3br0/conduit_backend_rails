class Article < ApplicationRecord
    has_one_attached :image
    has_many :comments, dependent: :destroy # 関連するコメントも削除する設定を追加


    def self.popular_tags
        # MySQLの機能を使ったPopular Tagsのクエリを実行する
        popular_tags = select('JSON_EXTRACT(tag_list, "$[*]") AS tag').pluck(:tag).flatten.group_by(&:itself).transform_values(&:count).sort_by { |_, v| -v }.to_h.keys
    end
end
