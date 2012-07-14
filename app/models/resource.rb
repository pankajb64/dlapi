class Resource < ActiveRecord::Base

def self.calculate_result(data)

  format = data[:format]
  level = data[:level]
  r1 = calculate_resource(format, data[:T1])
  r2 = calculate_resource(format, data[:T2])
  g50 = G50.find_by_level(level).value
  result = determine_result(r1, r2, data, g50)
  return result
end

end
