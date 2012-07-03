class CreateResources < ActiveRecord::Migration

  def up
    create_table :resources do |t|
      t.string :format
      t.integer :wickets # no. of wickets lost
      t.decimal :over, :scale => 1 # no. of overs left
      t.decimal :resource, :scale => 1
    end
  end
  
  def down
    drop_table :resources
  end
  
end        
