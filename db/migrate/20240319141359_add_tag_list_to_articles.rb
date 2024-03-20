class AddTagListToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :tag_list, :json
  end
end
