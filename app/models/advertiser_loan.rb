class AdvertiserLoan < ActiveRecord::Base

    belongs_to :partner
    belongs_to :sniff
    
    has_many :advertiser_loans_states
    has_many :states, through: :advertiser_loans_states
    accepts_nested_attributes_for :advertiser_loans_states, allow_destroy: true
   
    has_many :banners, as: :bannerable
    
    validates :partner_id, presence: true
    validates :partner_id, uniqueness: true    

    def self.by_top_rank
        order(ranking: :desc)
    end

    def self.by_low_cost
        order(cost: :asc)
    end

    def self.by_low_apr
        order(apr: :desc)
    end

    def self.active_lender
        where(active: :true)
    end    

    def self.paid
        where(paid: :true)
    end    

    def self.sniff_level(level)
		joins(:sniff).where("sniff_score <= ?", level)
    end

    #used in filter to choose by lender type
    def self.lender_type(type)
    	where("lender_type = ?", type)
    end

    #used in index to not show any 'match' lender types
    def self.not_lender_type(type)
        where("lender_type <> ?", type)
    end

    def self.rank_level(level)
    	where("ranking >= ?", level)
    end
end
