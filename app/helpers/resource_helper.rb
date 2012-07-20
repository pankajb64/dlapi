module ResourceHelper

def self.calculate_resource(format, data)

  n = data[:N]
  r = Resource.find_by_format_and_wickets_and_over(format, 0, n).resource
  
  data[:suspensions].each do |suspension|
  
    wickets = suspension[:wickets]
    overs_before = suspension[:overs_before]
    overs_after = suspension[:overs_after]
    
    r1 = Resource.find_by_format_and_wickets_and_over(format, wickets, overs_before).resource
    r2 = Resource.find_by_format_and_wickets_and_over(format, wickets, overs_after).resource

    diff = r1 - r2
    r = r - diff
  end
  
  return r
end

def self.determine_result(t1, t2, par_score)

  if (t2[:S] != nil && t2[:S] != -1)
    result = find_result(t1, t2, par_score)
  else
    result = find_target(t1, t2, par_score)
  end
  
  return result    
end

def self.calculate_par_score(r1, r2, s, g50)

  if r1 >= r2
    score = (r2/r1) * s
  else
    score = s + ((r2 - r1) * g50 )/ 100
  end
  
  return score.to_i    
end

def self.find_result(t1, t2, par_score)

  result = { :type => "result" }
  s = t2[:S]
  
  if ( par_score == s)
    result[:status] = "Tie"
  else
    result[:margin] = (par_score - s).abs  
    if ( par_score > s)
      result[:status] = "T1"
    else
      result[:status] = "T2"
    end
  end
  
  return result      

end

def self.find_target(t1, t2, par_score)

  target = { :type => "target"}
  score, overs_left, wickets  = find_current_score_and_overs_left_and_wickets_lost(t2)
  if wickets == nil
    wickets = 0
  end  
  t = par_score + 1
  target[:runs] = (t - score).abs
  target[:overs] = overs_left
  target[:wickets] = 10 - wickets
  
  return target
end

def self.find_current_score_and_overs_left_and_wickets_lost(t2)

  if t2[:suspensions].length == 0
    return 0, t2[:N], 0
  else 
    max = t2[:suspensions][0]
    t2[:suspensions].each do |suspension|
      if suspension[:overs_after] >= max[:overs_after] 
        max = suspension
      end  
    end
    #suspension = t2[:suspensions][t2[:suspensions].length - 1]
    return max[:score], max[:overs_after], max[:wickets]
  end   
end
  
end

