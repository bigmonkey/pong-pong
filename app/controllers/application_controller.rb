class ApplicationController < ActionController::Base
  protect_from_forgery
  
  #method defined below and redirects to home
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  #removed below sept15, 2014. learned that helpers aren't typically used by controllers. moved these methods to the bottom of Application Controller
  #include ApplicationHelper #include methods for mobile and tablet regex



  def wp
    redirect_to ("#{BASE_DOMAIN}/infos/lost/")
  end 

  private
  # determines type of device using user agent
  # tablets_agents, mobile_agents_one, and mobile_agents_two are RegEx in ApplicationHelper
  # must include ApplicationHelper see line above
  def set_device
      # if HTTP_USER_AGENT is blank/nil defaults to blank, i.e. desktop 
      agent = request.env["HTTP_USER_AGENT"].blank? ? "" : request.env["HTTP_USER_AGENT"].downcase 
      if agent =~ tablet_agents
        "tablet"
      elsif (agent =~ mobile_agents_one) || (agent[0..3] =~ mobile_agents_two)
        "mobile"
      else
        "desktop"
      end  
  end

  # TRACKING VARIABLES from external (put in URL pointing to PDH)
  # src -- the source of a visitor
  # camp -- the campaign of a visitor. this includes device, country
  # adg -- the ad groub of a visitor. 
  # kw -- the keyword of a visitor. 
  # ad -- the ad of a visitor. creative
  # plc -- the placement of a visitor. website.


  def set_tracking
    # set ad campaign stats if a source is in the url
    if cookies[:visitor_token].nil?
      begin
        visitor_token = SecureRandom.urlsafe_base64
      end while Applicant.exists?(:visitor_token => visitor_token)
      cookies[:visitor_token] = { value: visitor_token, expires: 30.days.from_now }
    end

  	if !params[:src].nil?
      session[:src] = params[:src] 
      session[:camp] = params[:camp]
      session[:adgrp] = params[:adg]
      session[:kw] = params[:kw]
      session[:ad] = params[:ad]
      session[:plc] = params[:plc]
    end

    # set site tracking stats
    if session[:page_views].nil?
      session[:page_views] = 1  
      #for direct visitors session[:referer_uri] is nil
      session[:referer_uri] = request.env["HTTP_REFERER"]
      session[:device] = set_device
      session[:entry_page] = request.fullpath
      session[:entry_time] = Time.now
    else
      session[:page_views] += 1
    end
  end

  def save_tracking

    @applicant = Applicant.new

    # assign tracking stats
    @applicant.ip_address = request.remote_ip
    @applicant.redirect = @redirect
    @applicant.device = session[:device]
    @applicant.src = session[:src] 
    @applicant.referer_uri = session[:referer_uri]
    if !session[:referer_uri].nil?
      uri = URI(session[:referer_uri])
      @applicant.referer_host = uri.host
      @applicant.referer_path = uri.path
      @applicant.referer_query = uri.query
    end  
    @applicant.entry_page = session[:entry_page]
    @applicant.page_views = session[:page_views]
    if !session[:entry_time].nil?
      @applicant.time_on_site = Time.at(Time.now - session[:entry_time]).utc.strftime("%H:%M:%S")
    end
    @applicant.exit_page = session[:exit_page]
    @applicant.visitor_token = cookies[:visitor_token]

    # assign campaign stats 
    @applicant.campaign = session[:camp]
    @applicant.ad_group = session[:adgrp]
    @applicant.kw = session[:kw]
    @applicant.creative = session[:ad]
    @applicant.placement = session[:plc]

    # save prequal variables
    @applicant.overdraft_protection = params[:overdraft_protection] 
    @applicant.payday_loan_history = params[:payday_loan_history] 
    @applicant.speed_sensitivity = params[:speed_sensitivity]
    @applicant.price_sensitivity = params[:price_sensitivity]
    @applicant.licensed_sensitivity = params[:licensed_sensitivity]
    @applicant.creditcard_own = params[:creditcard_own]
    @applicant.active_military = params[:active_military] 
    @applicant.eighteen = params[:eighteen]
    @applicant.state = params[:state]
    @applicant.bank_account_type = params[:bank_account_type]
    @applicant.requested_amount = session[:requested_amount]
    @applicant.save 
  
    # @applicant.token is created in model applicant.rb
    # session[:token] is set so it can be sent to affiliates for tracking
    session[:token]=@applicant.token
  end

  #in application because blogbars calls this method for wordpress
  def set_secured_constants
    @pur_balance =  500.0 #revolving purchase balance
    @cash_balance = 0.0 #cash balance balance
    @duration = 8.0  #number of months someone keeps the secured car, ad decimal so not integer  
  end
  
  #in application because blogbars calls this method for wordpress
  def set_prepaid_constants

    @atm_owner_fee = 2.50 #fee charged by ATM owners

    @direct_dep = false  #true -- has direct depoist. Values: true or false, case doesn't matter
    @wkly_trans = 8  #number of signature transactions
    @wkly_atm_in_net = 1 #number of atm in network cash withdrawels
    @wkly_atm_out_net = 0 #number of atm out of network cash withdrawals 
    @mthly_load =  1000 #average cash loaded to card
    @mthly_loads = 0 #number of loads
    @wkly_atm_inq = 0 #number of atm balance inquiries
    @calls = 0 #live customer service per month 
    @prepaid_duration = 24 #numner of months keeping the card  

    @max_wkly_purchase = 20
    @max_wkly_atm_in_net = 10 #number of atm cash withdrawels
    @max_wkly_atm_out_net = 10 #number of atm cash withdrawels    
    @max_mthly_load = 4000 # total amount of cash loaded onto card
    @max_mthly_loads = 8 #number of loads
    @max_wkly_atm_inq = 10 #number of atm balance inquiries
    @max_calls = 10 #number of calls to customer service per month
    @max_prepaid_duration = 48 #length of ownership

  end

  def set_seo_vars
      # for customizing articles for SEO
      # @keyword.category broken into three categories: custom, custom_state, loans, and lenders. Used for copy choices in index
      #   custom -- feeds text from table
      #   custom_state -- feeds text from table plus adds state selector
      #   loans/lenders -- uses copy for loans/lenders
      # @keyword.controller is used in routes to direct kw to correct controller. Issues with making one controller and one lender tables is need to make separate rows for term and payday for pricing and then when calling lender from Wordpress it's not clear which row to use. Solution is to create new tables for pricing and keep lender information as single row. 
      # @keyword.word seo target kw
      # @keyword.state_phrase the title of the state selector table. ex compare plural
      # @keyword.phrase seo target kw in a phrase with a plural noun . Copy assumes plural. Quick Loan becomes Quick Loan Options
      # @keyword.slug IS NOT USED ANYMORE see below
      # --------- future update -------- noticed 12/9/2013
      # NOTE slug and word must be exactly the same except for spaces.
      # find_by_slug and @selector_path but to do related_keywords array could not use slug so used gsub
      # improvement -- remove this dependency and use gsub.
      # --------- update completed: @keyword.slug is no longer used 1/7/2014 --------

      #captures stuff between first two slases
      #slug = request.fullpath.split(/\//)[1].downcase
      # changed fullpath to path because params with /? remove / so params were getting included
      slug = request.path.split(/\//)[1].downcase

      #used in state_selector
      @selector_path = "/"+slug 

      # find_by! raised RecordNotFound exception if no record exits. private method below escapes exception and redirects to home
      @keyword = Keyword.find_by_word!(slug.gsub('-',' ')) 

      # related_kw_links is used to make sure all kw's are hooked into site tree
      # All must be linked back to a kw on one of the major menu pages such as: /payday-loans, /installment-loans or /learn
      # for /payday-loans and /installment-loans these pages show up automatically using related_kw_links
      related_keywords = Keyword.where(:parent_page => @keyword.word).pluck(:word) - [].push(@keyword.word)  #remove current kw because don't want list of related kw containing the same kw
      @related_kw_links = []
      related_keywords.each do |word|
        @related_kw_links.push("<a href = \"/#{word.gsub(' ','-')}/\">#{word}</a>") #creates links for the related kws
      end  
  end


  # creates an array of states offered by the lender
  def offered_states (lender)
    @offered_states = []
    if (!lender.nil?) && (!lender.states.blank?)
      lender.states.each do |l|
        @offered_states.push(l.state_abbr)
      end
    end  
  end

  # creates an array of lenders making loans in a given state
  # assumes three models:TermLoan, PaydayLoan, AdvertiserLoan
  def paid_lenders(type, state_abbr)
    @paid_lenders = State.find_by_state_abbr(state_abbr).send(type+"_loans").lender_type(type).paid.by_top_rank
  end

  # select a banner based on rotation_rank weighting
  # the more weigthing the higher the odds of selections
  # banners with 0 rotation ranks are skipped
  def paid_banner(state_abbr)
    banners = []
    banner_weights = 0
    Banner.all.each do |b|
      offered_states(b.bannerable)
      if @offered_states.include?(state_abbr.upcase)
        banners.push(b) 
        banner_weights = banner_weights + b.rotation_rank
      end
    end

    if banners.empty?
      @paid_banner = nil
    else
      banner_choice = rand(0..banner_weights)
      i = 0
      banner_count = 0
      begin
        if banners[i].rotation_rank.blank? || banners[i].rotation_rank==0
          i+=1
        else
          banner_count = banner_count + banners[i].rotation_rank
          if banner_count >= banner_choice
            done = true
          else
            i+=1
          end
        end  
      end until done  

      @paid_banner = banners[i]
    end
    
  end

  def paid_partner(id)
    paid_partner_ids = []
    PaydayLoan.all.each do |t|
      if t.paid
        paid_partner_ids.push(t.partner_id)
      end
    end
    TermLoan.all.each do |t|
      if t.paid
        paid_partner_ids.push(t.partner_id)
      end
    end
    id.in?paid_partner_ids
  end


  #tablet regex from https://github.com/benlangfeld/mobile-fu/blob/master/lib/mobile-fu/tablet.rb
  def tablet_agents 
    /ipad|ipad.*mobile|^.*android.*nexus(((?:(?!mobile))|(?:(\s(7|10).+))).)*$|samsung.*tablet|galaxy.*tab|sc-01c|gt-p1000|gt-p1003|gt-p1010|gt-p3105|gt-p6210|gt-p6800|gt-p6810|gt-p7100|gt-p7300|gt-p7310|gt-p7500|gt-p7510|sch-i800|sch-i815|sch-i905|sgh-i957|sgh-i987|sgh-t849|sgh-t859|sgh-t869|sph-p100|gt-p3100|gt-p3108|gt-p3110|gt-p5100|gt-p5110|gt-p6200|gt-p7320|gt-p7511|gt-n8000|gt-p8510|sgh-i497|sph-p500|sgh-t779|sch-i705|sch-i915|gt-n8013|gt-p3113|gt-p5113|gt-p8110|gt-n8010|gt-n8005|gt-n8020|gt-p1013|gt-p6201|gt-p7501|gt-n5100|gt-n5110|shv-e140k|shv-e140l|shv-e140s|shv-e150s|shv-e230k|shv-e230l|shv-e230s|shw-m180k|shw-m180l|shw-m180s|shw-m180w|shw-m300w|shw-m305w|shw-m380k|shw-m380s|shw-m380w|shw-m430w|shw-m480k|shw-m480s|shw-m480w|shw-m485w|shw-m486w|shw-m500w|gt-i9228|sch-p739|sch-i925|gt-i9200|gt-i9205|gt-p5200|gt-p5210|sm-t311|sm-t310|sm-t210|sm-t210r|sm-t211|sm-p600|sm-p601|sm-p605|sm-p900|sm-t217|sm-t217a|sm-t217s|sm-p6000|sm-t3100|sgh-i467|xe500|kindle|silk.*accelerated|android.*\b(kfot|kftt|kfjwi|kfjwa|kfote|kfsowi|kfthwi|kfthwa|kfapwi|kfapwa|wfjwae)\b|windows nt [0-9.]+; arm;|hp slate 7|hp elitepad 900|hp-tablet|elitebook.*touch|^.*padfone((?!mobile).)*$|transformer|tf101|tf101g|tf300t|tf300tg|tf300tl|tf700t|tf700kl|tf701t|tf810c|me171|me301t|me302c|me371mg|me370t|me372mg|me172v|me173x|me400c|slider sl101|playbook|rim tablet|htc flyer|htc jetstream|htc-p715a|htc evo view 4g|pg41200|xoom|sholest|mz615|mz605|mz505|mz601|mz602|mz603|mz604|mz606|mz607|mz608|mz609|mz615|mz616|mz617|android.*nook|nookcolor|nook browser|bnrv200|bnrv200a|bntv250|bntv250a|bntv400|bntv600|logicpd zoom2|android.*; \b(a100|a101|a110|a200|a210|a211|a500|a501|a510|a511|a700|a701|w500|w500p|w501|w501p|w510|w511|w700|g100|g100w|b1-a71|b1-710|b1-711|a1-810)\b|w3-810|android.*(at100|at105|at200|at205|at270|at275|at300|at305|at1s5|at500|at570|at700|at830)|toshiba.*folio|\bl-06c|lg-v900|lg-v909\b|android.*\b(f-01d|f-05e|f-10d|m532|q572)\b|pmp3170b|pmp3270b|pmp3470b|pmp7170b|pmp3370b|pmp3570c|pmp5870c|pmp3670b|pmp5570c|pmp5770d|pmp3970b|pmp3870c|pmp5580c|pmp5880d|pmp5780d|pmp5588c|pmp7280c|pmp7280|pmp7880d|pmp5597d|pmp5597|pmp7100d|per3464|per3274|per3574|per3884|per5274|per5474|pmp5097cpro|pmp5097|pmp7380d|pmp5297c|pmp5297c_quad|ideatab|s2110|s6000|k3011|a3000|a1000|a2107|a2109|a1107|thinkpad([ ]+)?tablet|android.*(tab210|tab211|tab224|tab250|tab260|tab264|tab310|tab360|tab364|tab410|tab411|tab420|tab424|tab450|tab460|tab461|tab464|tab465|tab467|tab468)|android.*\boyo\b|life.*(p9212|p9514|p9516|s9512)|lifetab|an10g2|an7bg3|an7fg3|an8g3|an8cg3|an7g3|an9g3|an7dg3|an7dg3st|an7dg3childpad|an10bg3|an10bg3dt|m702pro|megafon v9|\bzte v9\b|e-boda (supreme|impresspeed|izzycomm|essential)|allview.*(viva|alldro|city|speed|all tv|frenzy|quasar|shine|tx1|ax1|ax2)|\b(101g9|80g9|a101it)\b|qilive 97r|novo7|novo8|novo10|novo7aurora|novo7basic|novo7paladin|novo9-spark|sony.*tablet|xperia tablet|sony tablet s|so-03e|sgpt12|sgpt13|sgpt114|sgpt121|sgpt122|sgpt123|sgpt111|sgpt112|sgpt113|sgpt131|sgpt132|sgpt133|sgpt211|sgpt212|sgpt213|sgp311|sgp312|sgp321|ebrd1101|ebrd1102|ebrd1201|android.*(k8gt|u9gt|u10gt|u16gt|u17gt|u18gt|u19gt|u20gt|u23gt|u30gt)|cube u8gt|mid1042|mid1045|mid1125|mid1126|mid7012|mid7014|mid7015|mid7034|mid7035|mid7036|mid7042|mid7048|mid7127|mid8042|mid8048|mid8127|mid9042|mid9740|mid9742|mid7022|mid7010|m9701|m9000|m9100|m806|m1052|m806|t703|mid701|mid713|mid710|mid727|mid760|mid830|mid728|mid933|mid125|mid810|mid732|mid120|mid930|mid800|mid731|mid900|mid100|mid820|mid735|mid980|mid130|mid833|mid737|mid960|mid135|mid860|mid736|mid140|mid930|mid835|mid733|android.*(\bmid\b|mid-560|mtv-t1200|mtv-pnd531|mtv-p1101|mtv-pnd530)|android.*(rk2818|rk2808a|rk2918|rk3066)|rk2738|rk2808a|iq310|fly vision|bq.*(elcano|curie|edison|maxwell|kepler|pascal|tesla|hypatia|platon|newton|livingstone|cervantes|avant)|maxwell.*lite|maxwell.*plus|mediapad|ideos s7|s7-201c|s7-202u|s7-101|s7-103|s7-104|s7-105|s7-106|s7-201|s7-slim|\bn-06d|\bn-08d|pantech.*p4100|broncho.*(n701|n708|n802|a710)|touchpad.*[78910]|\btouchtab\b|z1000|z99 2g|z99|z930|z999|z990|z909|z919|z900|tb07sta|tb10sta|tb07fta|tb10fta|android.*\bnabi|kobo touch|\bk080\b|\bvox\b build|\barc\b build|dslide.*\b(700|701r|702|703r|704|802|970|971|972|973|974|1010|1012)\b|navipad|tb-772a|tm-7045|tm-7055|tm-9750|tm-7016|tm-7024|tm-7026|tm-7041|tm-7043|tm-7047|tm-8041|tm-9741|tm-9747|tm-9748|tm-9751|tm-7022|tm-7021|tm-7020|tm-7011|tm-7010|tm-7023|tm-7025|tm-7037w|tm-7038w|tm-7027w|tm-9720|tm-9725|tm-9737w|tm-1020|tm-9738w|tm-9740|tm-9743w|tb-807a|tb-771a|tb-727a|tb-725a|tb-719a|tb-823a|tb-805a|tb-723a|tb-715a|tb-707a|tb-705a|tb-709a|tb-711a|tb-890hd|tb-880hd|tb-790hd|tb-780hd|tb-770hd|tb-721hd|tb-710hd|tb-434hd|tb-860hd|tb-840hd|tb-760hd|tb-750hd|tb-740hd|tb-730hd|tb-722hd|tb-720hd|tb-700hd|tb-500hd|tb-470hd|tb-431hd|tb-430hd|tb-506|tb-504|tb-446|tb-436|tb-416|tb-146se|tb-126se|playstation.*(portable|vita)|android.*\bg1\b|funbook|micromax.*\b(p250|p560|p360|p362|p600|p300|p350|p500|p275)\b|android.*\b(a39|a37|a34|st8|st10|st7|smart tab3|smart tab2)\b|fine7 genius|fine7 shine|fine7 air|fine8 style|fine9 more|fine10 joy|fine11 wide|\b(pem63|plt1023g|plt1041|plt1044|plt1044g|plt1091|plt4311|plt4311pl|plt4315|plt7030|plt7033|plt7033d|plt7035|plt7035d|plt7044k|plt7045k|plt7045kb|plt7071kg|plt7072|plt7223g|plt7225g|plt7777g|plt7810k|plt7849g|plt7851g|plt7852g|plt8015|plt8031|plt8034|plt8036|plt8080k|plt8082|plt8088|plt8223g|plt8234g|plt8235g|plt8816k|plt9011|plt9045k|plt9233g|plt9735|plt9760g|plt9770g)\b|bq1078|bc1003|bc1077|rk9702|bc9730|bc9001|it9001|bc7008|bc7010|bc708|bc728|bc7012|bc7030|bc7027|bc7026|tpc7102|tpc7103|tpc7105|tpc7106|tpc7107|tpc7201|tpc7203|tpc7205|tpc7210|tpc7708|tpc7709|tpc7712|tpc7110|tpc8101|tpc8103|tpc8105|tpc8106|tpc8203|tpc8205|tpc8503|tpc9106|tpc9701|tpc97101|tpc97103|tpc97105|tpc97106|tpc97111|tpc97113|tpc97203|tpc97603|tpc97809|tpc97205|tpc10101|tpc10103|tpc10106|tpc10111|tpc10203|tpc10205|tpc10503|tx-a1301|tx-m9002|q702|tab-p506|tab-navi-7-3g-m|tab-p517|tab-p-527|tab-p701|tab-p703|tab-p721|tab-p731n|tab-p741|tab-p825|tab-p905|tab-p925|tab-pr945|tab-pl1015|tab-p1025|tab-pi1045|tab-p1325|tab-protab[0-9]+|tab-protab25|tab-protab26|tab-protab27|tab-protab26xl|tab-protab2-ips9|tab-protab30-ips9|tab-protab25xxl|tab-protab26-ips10|tab-protab30-ips10|ov-(steelcore|newbase|basecore|baseone|exellen|quattor|edutab|solution|action|basictab|teddytab|magictab|stream|tb-08|tb-09)|hcl.*tablet|connect-3g-2.0|connect-2g-2.0|me tablet u1|me tablet u2|me tablet g1|me tablet x1|me tablet y2|me tablet sync|dps dream 9|dps dual 7|v97 hd|i75 3g|visture v4( hd)?|visture v5( hd)?|visture v10|ctp(-)?810|ctp(-)?818|ctp(-)?828|ctp(-)?838|ctp(-)?888|ctp(-)?978|ctp(-)?980|ctp(-)?987|ctp(-)?988|ctp(-)?989|\bmt8125|mt8389|mt8135|mt8377\b|concorde([ ]+)?tab|concorde readman|goclever tab|a7goclever|m1042|m7841|m742|r1042bk|r1041|tab a975|tab a7842|tab a741|tab a741l|tab m723g|tab m721|tab a1021|tab i921|tab r721|tab i720|tab t76|tab r70|tab r76.2|tab r106|tab r83.2|tab m813g|tab i721|gcta722|tab i70|tab i71|tab s73|tab r73|tab r74|tab r93|tab r75|tab r76.1|tab a73|tab a93|tab a93.2|tab t72|tab r83|tab r974|tab r973|tab a101|tab a103|tab a104|tab a104.2|r105bk|m713g|a972bk|tab a971|tab r974.2|tab r104|tab r83.3|tab a1042|freetab 9000|freetab 7.4|freetab 7004|freetab 7800|freetab 2096|freetab 7.5|freetab 1014|freetab 1001 |freetab 8001|freetab 9706|freetab 9702|freetab 7003|freetab 7002|freetab 1002|freetab 7801|freetab 1331|freetab 1004|freetab 8002|freetab 8014|freetab 9704|freetab 1003|hudl ht7s3|t-hub2|android.*\b97d\b|tablet(?!.*pc)|viewpad7|bntv250a|mid-wcdma|logicpd zoom2|\ba7eb\b|catnova8|a1_07|ct704|ct1002|\bm721\b|rk30sdk|\bevotab\b|smarttabii10|smarttab10|m758a|et904/   
  end
  # mobile regex from http://detectmobilebrowsers.com/
  def mobile_agents_one
    /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i
  end
  def mobile_agents_two
    /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i
  end

  # gets called by find_by bang above if no record found
  def record_not_found
    redirect_to("#{BASE_DOMAIN}/infos/lost/")
  end

end
