class Api::TagsController < ApplicationController
    def popular
      # MySQLのJSON_EXTRACT関数を使用して、tag_listからタグを取得する
        popular_tags = Article.pluck(Arel.sql("JSON_UNQUOTE(JSON_EXTRACT(tag_list, '$[*]'))")).flatten.group_by(&:itself).transform_values(&:count).sort_by { |_, v| -v }.to_h.keys
        render json: { popular_tags: popular_tags }
    end
end
