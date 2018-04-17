class CreatePhotos < ActiveRecord::Migration[5.1]
  def change
    create_table :photos do |t|
      t.string :user_id
      t.datetime :date_time
      t.string :file_name
    end
  end
end
