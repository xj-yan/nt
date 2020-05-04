class UpdateUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tweet_number, :integer, default: 0
  end
end
