class CreateApplications < ActiveRecord::Migration[5.2]
  def change
    create_table :applications do |t|
      t.string :token
      t.string :name
      t.integer :chat_count
      t.index :token
      t.timestamps
    end
  end
end
