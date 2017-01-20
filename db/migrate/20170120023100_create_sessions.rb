class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.string :token
      t.boolean :active, null: false, default: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :sessions, :token, unique: true
  end
end
