class CreateMassIndexRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :mass_index_records do |t|
      t.decimal :body_max_index, null: false, default: 0.0
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
