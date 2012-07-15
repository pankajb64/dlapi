class Resource < ActiveRecord::Base

def self.calculate_result(data)

  format = data[:format]
  level = data[:level]
  s = data[:T1][:S]
  r1 = ResourceHelper.calculate_resource(format, data[:T1])
  r2 = ResourceHelper.calculate_resource(format, data[:T2])
  g50 = G50.find_by_level(level).value
  par_score = ResourceHelper.calculate_par_score(r1, r2, s, g50)
  result = ResourceHelper.determine_result(data[:T1], data[:T2], par_score)
  return result
end

end
