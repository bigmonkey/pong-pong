class TermLoan < ActiveRecord::Base
  # attr_accessible :title, :body
    belongs_to :partner
    belongs_to :sniff
    
    has_many :states_term_loans
    has_many :states, through: :states_term_loans
    accepts_nested_attributes_for :states_term_loans, allow_destroy: true

    has_many :banners, as: :bannerable

    #has_and_belongs_to_many :states

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
