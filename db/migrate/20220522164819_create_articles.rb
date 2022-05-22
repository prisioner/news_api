class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :anounce
      t.text :body
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
