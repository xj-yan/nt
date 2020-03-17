class CreateHasTags < ActiveRecord::Migration[6.0]
  def change
  	create_table :has_tags do |t|
      t.integer :tweet_id
      t.integer :tag_id
    end
  end
end
