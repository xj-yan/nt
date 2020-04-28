class UpdateTweets < ActiveRecord::Migration[6.0]
  def change
    change_column :tweets, :mention_str, :string, default: ''
    change_column :tweets, :tag_str, :string, default: ''
  end
end
