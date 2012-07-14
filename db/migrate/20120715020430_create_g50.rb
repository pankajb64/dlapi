class CreateG50 < ActiveRecord::Migration

  def up
  
    create_table :g50s do |t|
    
      t.string :level
      t.integer :value
    end
    
  end
  
  
  def down
  
    drop_table :g50s
  end
  
end        
