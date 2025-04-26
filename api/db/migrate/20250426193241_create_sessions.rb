class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.boolean :active, default: true, null: false
      t.integer :duration, null: false
      t.date :played_at, null: false
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
