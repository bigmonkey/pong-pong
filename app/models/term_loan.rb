class TermLoan < ActiveRecord::Base
  # attr_accessible :title, :body
    belongs_to :partner
    belongs_to :sniff
    has_and_belongs_to_many :states

    validates :partner_id, presence: true
    validates :partner_id, uniqueness: true

    scope :by_top_rank, order("term_loans.ranking DESC")
    scope :by_low_cost, order("term_loans.cost ASC")
    scope :by_low_apr, order("term_loans.apr ASC")
    scope :active_lender, -> { where active: true }


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
