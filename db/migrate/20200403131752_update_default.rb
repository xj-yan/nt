class UpdateDefault < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :follower_number, :integer, default: 0
    change_column :users, :followee_number, :integer, default: 0
  end
end
