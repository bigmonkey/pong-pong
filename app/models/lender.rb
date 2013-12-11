class Lender < ActiveRecord::Base
    # attr_accessible :sniff_id, :ranking
  
    has_one :partner, {:foreign_key => "id"}
    belongs_to :sniff
    has_and_belongs_to_many :states
    has_and_belongs_to_many :term_states

    def self.by_top_rank
        order(ranking: :desc)
    end

    def self.by_low_cost
        order(cost: :asc)
    end

    def self.by_low_apr
        order(apr: :desc)
    end

    def self.sniff_level(level)
		where("sniff_id <= ?", level)
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