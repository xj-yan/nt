class CreateTweets < ActiveRecord::Migration[6.0]
  def change
  	create_table :tweets do |t|
      t.string :tweet
      t.integer :user_id
      t.string :tag_str
      t.string :mention_str
      t.timestamps
    end
  end
end
