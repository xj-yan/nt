class CreateFollows < ActiveRecord::Migration[6.0]
  def change
  	create_table :follows do |t|
      t.integer :fan_id
      t.integer :idol_id
     end
  end
end
