class CreateSubmissions < ActiveRecord::Migration[6.1]
  def change
    create_table :submissions do |t|
      t.string :artist
      t.text :comment
      t.integer :user_id
      t.text :jacket
      t.text :resource
      t.string :music
      t.string :album
    end
  end
end
