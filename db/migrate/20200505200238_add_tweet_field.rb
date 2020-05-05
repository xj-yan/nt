class AddTweetField < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :username, :string
  end
end
