class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :micropost_id
      t.integer :visitor_id
      t.integer :visited_id
      t.integer :reply_id
      t.string :activity
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
