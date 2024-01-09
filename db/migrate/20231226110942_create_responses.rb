class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses do |t|
      t.references :conversation, null: false, foreign_key: true
      t.string :model
      t.text :text

      t.timestamps
    end
  end
end
