class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :number
      t.integer :message_count
      t.index :number
      t.timestamps
    end
  end
end
