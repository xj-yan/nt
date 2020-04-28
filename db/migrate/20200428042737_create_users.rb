class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.text :bio
      t.string :password_digest
      t.integer :follower_number
      t.integer :followee_number
    end
  end
end
