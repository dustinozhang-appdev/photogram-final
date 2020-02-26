class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :comments_count
      t.integer :likes_count
      t.string :password
      t.boolean :private
      t.string :username
    end
  end
end
