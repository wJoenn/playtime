class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.integer :appid
      t.string :name, null: false
      t.string :cover_url, null: false

      t.timestamps
    end

    add_index :games, :appid, unique: true
  end
end
