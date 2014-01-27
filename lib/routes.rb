# used in the main routes.rb file
# sets up dynamic routes based on Keyword table
# it is done via match constraint: so the database is not accessed during precompile on heroku
# the rack solution although more elegant isn't compatible with rspec
# 
# The way it works based on this from http://guides.rubyonrails.org/routing.html
#
# 3.10 Advanced Constraints
# If you have a more advanced constraint, you can provide an object that responds 
# to matches? that Rails should use. 


class KeywordChecker

  def correct_kw_controller?(path_bits, controller)
    # see if the KW exits and it matches the controller
    (kw = Keyword.find_by_word(path_bits[1].gsub('-',' ').downcase)) ? controller == kw.controller  : false
  end

  def seo_go?(request, controller, action)
    path_bits = request.fullpath.split(/\//)
    if path_bits[3].nil?        # if it has three / then it's not right
      if action == "index"
        if !path_bits[2].nil?   # if it's index it should have no second slash
          false
        else                    
          correct_kw_controller?(path_bits, controller)      
        end
      else
        if State.exists?(state_abbr: path_bits[2].upcase)  # see if the second slash is a sate
          correct_kw_controller?(path_bits, controller)
        else
          false
        end
      end
    else
      false 
    end  
  end

end  

class SEOTermState < KeywordChecker
  def matches?(request)
    seo_go?(request, "term", "show")
  end
end 

class SEOTermIndex < KeywordChecker
  def matches?(request)
    seo_go?(request, "term", "index")
  end
end 

class SEOPaydayState < KeywordChecker
  def matches?(request)
    seo_go?(request, "payday", "show")
  end
end   

class SEOPaydayIndex < KeywordChecker
  def matches?(request)
    seo_go?(request, "payday", "index")
  end
end 