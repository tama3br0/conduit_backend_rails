class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.string :author_name
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
