class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :number
      t.string :message
      t.index :number
      t.index :message
      t.timestamps
    end
  end
end
