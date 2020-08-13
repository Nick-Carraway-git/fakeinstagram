class AddUsersInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :username, :string, nill: false, unique: true
    add_column :users, :website, :string
    add_column :users, :introduce, :text
    add_column :users, :tel, :integer
    add_column :users, :gender, :string
  end
end
