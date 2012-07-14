class AddG50Values < ActiveRecord::Migration

  G50_VALUES = [
  
    { :level => "Standard", :value => 245 },
    { :level => "U19", :value => 200 },
    { :level => "U15", :value => 200 },
    { :level => "WInt", :value => 200 },
    { :level => "Associate", :value => 200 },
  ]
  
  def up
  
    G50_VALUES.each do |g50|
    
      G50.create!(g50)
    end
  end
  
  
  def down
  
    G50_VALUES.each do |g50|
    
      G50.find_by_level(g50[:level]).destroy
    end
  end
  
end          
