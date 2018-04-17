class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.string :user_id
      t.string :photo_id
      t.datetime :date_time
      t.text :comment_text
    end
  end
end
