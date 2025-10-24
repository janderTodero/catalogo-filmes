class CreateImports < ActiveRecord::Migration[8.0]
  def change
    create_table :imports do |t|
      t.references :user, null: false, foreign_key: true
      t.string :file
      t.string :status

      t.timestamps
    end
  end
end
