require 'active_support'

class ResourcesController < ApplicationController

def determine_result

  j = ActiveSupport::JSON
  
  @data = j.decode(params[:data], :symbolize_keys => true)
  @result = Resource.calculate_result(@data)
  render :json => j.encode(@result)
end

def index

  
end  
end
