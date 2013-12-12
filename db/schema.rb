# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131110033241) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applicants", force: true do |t|
    t.string   "token"
    t.string   "ip_address"
    t.string   "src_code",             limit: 4
    t.string   "page_code",            limit: 4
    t.string   "campaign"
    t.string   "ad_group"
    t.string   "kw"
    t.string   "creative"
    t.string   "placement"
    t.string   "bank_account_type",    limit: 8
    t.boolean  "active_military"
    t.boolean  "eighteen"
    t.string   "state",                limit: 2
    t.boolean  "overdraft_protection"
    t.integer  "payday_loan_history"
    t.integer  "speed_sensitivity"
    t.integer  "price_sensitivity"
    t.integer  "licensed_sensitivity"
    t.boolean  "creditcard_own"
    t.string   "redirect"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "borrowers", force: true do |t|
    t.string   "token"
    t.string   "ip_address"
    t.string   "first_name",                 limit: 128
    t.string   "last_name",                  limit: 128
    t.string   "address",                    limit: 128
    t.string   "city",                       limit: 128
    t.string   "state",                      limit: 2
    t.string   "zip"
    t.integer  "address_length_months"
    t.string   "ssn",                        limit: 11
    t.string   "bir_year"
    t.string   "bir_mth"
    t.string   "bir_day"
    t.boolean  "own_home"
    t.string   "home_phone",                 limit: 12
    t.string   "drivers_license_number",     limit: 128
    t.string   "drivers_license_state",      limit: 2
    t.string   "email",                      limit: 128
    t.string   "best_time_to_call",          limit: 12
    t.string   "bank_aba"
    t.integer  "bank_account_length_months"
    t.string   "bank_account_number"
    t.string   "bank_account_type",          limit: 8
    t.string   "bank_name",                  limit: 128
    t.string   "bank_phone",                 limit: 12
    t.boolean  "direct_deposit"
    t.string   "employer",                   limit: 128
    t.string   "job_title",                  limit: 128
    t.integer  "monthly_income"
    t.string   "income_type",                limit: 12
    t.string   "work_phone",                 limit: 12
    t.date     "pay_date1"
    t.date     "pay_date2"
    t.string   "pay_frequency",              limit: 12
    t.integer  "employed_months"
    t.boolean  "active_military"
    t.integer  "requested_amount"
    t.string   "pingtree"
    t.string   "status"
    t.string   "leadid"
    t.decimal  "sold_price",                             precision: 8, scale: 2
    t.string   "redirect"
    t.text     "error_description"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
  end

  create_table "keywords", force: true do |t|
    t.string "word"
    t.string "phrase"
    t.string "state_phrase"
    t.string "slug"
    t.string "category"
    t.text   "article"
    t.string "parent_page"
    t.string "controller"
    t.string "created_at",   null: false
    t.string "updated_at",   null: false
  end

  create_table "lenders", force: true do |t|
    t.integer  "sniff_id"
    t.string   "name",              limit: 45
    t.string   "lender_type",       limit: 45
    t.string   "image_file"
    t.decimal  "ranking",                      precision: 3, scale: 1
    t.string   "first_comment"
    t.string   "second_comment"
    t.string   "third_comment"
    t.string   "since",             limit: 4
    t.string   "governing_law",     limit: 45
    t.boolean  "BBB_accredit"
    t.string   "BBB_score",         limit: 4
    t.integer  "BBB_complaints"
    t.integer  "BBB_unresponded"
    t.string   "max_loan",          limit: 45
    t.boolean  "spanish"
    t.boolean  "state_lic"
    t.boolean  "privacy_policy"
    t.boolean  "https"
    t.boolean  "phone_contact"
    t.boolean  "live_chat"
    t.boolean  "time_at_residence"
    t.boolean  "rent_or_own"
    t.boolean  "rent_mort_amt"
    t.boolean  "time_w_employer"
    t.boolean  "reference"
    t.decimal  "loan_amt",                     precision: 6, scale: 2
    t.decimal  "payments",                     precision: 4, scale: 1
    t.decimal  "pmt_freq_in_days",             precision: 5, scale: 1
    t.decimal  "pmt_amt",                      precision: 7, scale: 2
    t.decimal  "cost",                         precision: 7, scale: 2
    t.decimal  "apr",                          precision: 3, scale: 2
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "review_url"
    t.integer  "partner_id"
  end

  add_index "lenders", ["sniff_id"], name: "index_lenders_on_sniff_id", using: :btree

  create_table "lenders_states", id: false, force: true do |t|
    t.integer "lender_id"
    t.integer "state_id"
  end

  add_index "lenders_states", ["lender_id", "state_id"], name: "index_lenders_states_on_lender_id_and_state_id", using: :btree

  create_table "lenders_term_states", id: false, force: true do |t|
    t.integer "lender_id"
    t.integer "term_state_id"
  end

  add_index "lenders_term_states", ["lender_id", "term_state_id"], name: "index_lenders_term_states_on_lender_id_and_term_state_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "page_name",  limit: 50
    t.string   "page_code",  limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "pages", ["page_code"], name: "index_pages_on_page_code", unique: true, using: :btree

  create_table "partners", force: true do |t|
    t.string   "lender_link"
    t.string   "lender_tail", limit: 25
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "name",        limit: 100
  end

  create_table "payday_loan_law_details", force: true do |t|
    t.string   "state_abbr"
    t.string   "ncsl_citation"
    t.text     "ncsl_max_loans"
    t.text     "ncsl_max_term"
    t.text     "ncsl_citation_excerpt"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "payday_loan_laws", force: true do |t|
    t.string  "state_abbr"
    t.string  "name"
    t.string  "legal_status_summary"
    t.string  "legal_status"
    t.text    "citation"
    t.string  "max_loan"
    t.string  "term"
    t.text    "max_rates"
    t.string  "fee_14day_100"
    t.string  "apr_14day_100"
    t.string  "max_loans_out"
    t.string  "rollovers"
    t.string  "cooling_period"
    t.string  "repay_plan"
    t.boolean "collection_terms"
    t.string  "collect_fee"
    t.string  "criminal_action"
    t.string  "regulator"
    t.string  "regulator_division"
    t.string  "regulator_address"
    t.string  "regulator_city"
    t.string  "regulator_zip"
    t.string  "regulator_phone"
    t.string  "regulator_fax"
    t.string  "regulator_contact"
    t.string  "regulator_site"
    t.boolean "additional_resources"
    t.string  "license_database"
    t.string  "complaint_form"
    t.string  "complaint_instructions"
    t.string  "resource_one_title"
    t.string  "resource_one"
    t.string  "resource_two_title"
    t.string  "resource_two"
    t.string  "created_at",             null: false
    t.string  "updated_at",             null: false
  end

  create_table "payday_loans", force: true do |t|
    t.integer  "sniff_id"
    t.integer  "partner_id"
    t.string   "name",                                      default: ""
    t.boolean  "active"
    t.string   "lender_type"
    t.string   "image_file"
    t.decimal  "ranking",           precision: 3, scale: 1
    t.string   "first_comment"
    t.string   "second_comment"
    t.string   "third_comment"
    t.string   "review_url"
    t.string   "since"
    t.string   "governing_law",                             default: ""
    t.boolean  "BBB_accredit"
    t.string   "BBB_score"
    t.integer  "BBB_complaints"
    t.integer  "BBB_unresponded"
    t.string   "max_loan",                                  default: ""
    t.boolean  "spanish"
    t.boolean  "state_lic"
    t.boolean  "privacy_policy"
    t.boolean  "https"
    t.boolean  "phone_contact"
    t.boolean  "live_chat"
    t.boolean  "time_at_residence"
    t.boolean  "rent_or_own"
    t.boolean  "rent_mort_amt"
    t.boolean  "time_w_employer"
    t.boolean  "reference"
    t.decimal  "loan_amt",          precision: 6, scale: 2
    t.decimal  "payments",          precision: 4, scale: 1
    t.decimal  "pmt_freq_in_days",  precision: 5, scale: 1
    t.decimal  "pmt_amt",           precision: 7, scale: 2
    t.decimal  "cost",              precision: 7, scale: 2
    t.decimal  "apr",               precision: 3, scale: 2
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.text     "full_desc"
    t.string   "image_file_big"
    t.string   "bbb_link"
    t.string   "link1_desc"
    t.string   "link1"
    t.string   "link2_desc"
    t.string   "link2"
  end

  create_table "payday_loans_states", id: false, force: true do |t|
    t.integer "payday_loan_id"
    t.integer "state_id"
  end

  add_index "payday_loans_states", ["payday_loan_id", "state_id"], name: "index_payday_loans_states_on_payday_loan_id_and_state_id", using: :btree

  create_table "prepaids", force: true do |t|
    t.integer  "partner_id"
    t.string   "name",                    limit: 100
    t.string   "image_file",              limit: 100
    t.string   "card_name",               limit: 100
    t.decimal  "rating",                              precision: 3, scale: 1
    t.string   "credit_needed",           limit: 25
    t.string   "first_comment",           limit: 70
    t.string   "second_comment",          limit: 70
    t.string   "third_comment",           limit: 70
    t.decimal  "activation_fee",                      precision: 4, scale: 2
    t.decimal  "reduce_mth_fee_load_amt",             precision: 8, scale: 2
    t.decimal  "reduce_mth_fee",                      precision: 4, scale: 2
    t.decimal  "mth_fee_dep",                         precision: 4, scale: 2
    t.decimal  "mth_fee_no_dep",                      precision: 4, scale: 2
    t.decimal  "trans_fee_signature",                 precision: 4, scale: 2
    t.decimal  "atm_bal_fee",                         precision: 4, scale: 2
    t.decimal  "atm_out_net_fee",                     precision: 4, scale: 2
    t.decimal  "atm_in_net_fee_dep",                  precision: 4, scale: 2
    t.decimal  "atm_in_net_fee_no_dep",               precision: 4, scale: 2
    t.decimal  "load_fee",                            precision: 4, scale: 2
    t.decimal  "paper_statement",                     precision: 4, scale: 2
    t.decimal  "max_atm",                             precision: 8, scale: 2
    t.decimal  "max_bal",                             precision: 8, scale: 2
    t.decimal  "max_daily_spend",                     precision: 8, scale: 2
    t.decimal  "min_load",                            precision: 8, scale: 2
    t.decimal  "max_cash_deposit",                    precision: 8, scale: 2
    t.string   "bill_pay_elec",           limit: 70
    t.string   "bill_pay_paper",          limit: 70
    t.string   "online_acct",             limit: 20
    t.decimal  "call_fee_dep",                        precision: 4, scale: 2
    t.decimal  "call_fee_no_dep",                     precision: 4, scale: 2
    t.decimal  "free_calls",                          precision: 4, scale: 2
    t.string   "call_center_desc",        limit: 100
    t.text     "bullets"
    t.string   "issuer",                  limit: 100
    t.decimal  "payout",                              precision: 4, scale: 2
    t.boolean  "live"
    t.integer  "card_syn_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "review_url"
  end

  add_index "prepaids", ["review_url"], name: "index_prepaids_on_review_url", using: :btree

  create_table "secureds", force: true do |t|
    t.string   "name",           limit: 70
    t.string   "image_file",     limit: 100
    t.decimal  "rating",                     precision: 3, scale: 1
    t.string   "first_comment",  limit: 70
    t.string   "second_comment", limit: 70
    t.string   "third_comment",  limit: 70
    t.decimal  "purchase_apr",               precision: 4, scale: 2
    t.decimal  "annual_fee",                 precision: 5, scale: 2
    t.decimal  "monthly_fee",                precision: 4, scale: 2
    t.decimal  "cost",                       precision: 7, scale: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "partner_id"
    t.boolean  "inst_decision"
    t.string   "card_name"
    t.text     "bullets"
    t.string   "issuer",         limit: 100
    t.string   "card_type",      limit: 50
    t.string   "purchase_base",  limit: 1
    t.decimal  "cash_apr",                   precision: 4, scale: 2
    t.string   "cash_base",      limit: 1
    t.string   "grace",          limit: 50
    t.string   "late_fee",       limit: 20
    t.string   "return_pmt",     limit: 20
    t.string   "overlimit_fee",  limit: 20
    t.string   "max_credit",     limit: 20
    t.string   "min_deposit",    limit: 20
    t.string   "credit_rating",  limit: 20
    t.boolean  "live"
    t.string   "review_url"
  end

  add_index "secureds", ["review_url"], name: "index_secureds_on_review_url", using: :btree

  create_table "sniffs", force: true do |t|
    t.string   "sniff_desc", limit: 5
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "sources", force: true do |t|
    t.string   "src_code",   limit: 4
    t.string   "src_desc",   limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "sources", ["src_code"], name: "index_sources_on_src_code", unique: true, using: :btree

  create_table "states", force: true do |t|
    t.string   "state_abbr", limit: 2
    t.string   "state",      limit: 15
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "states_term_loans", id: false, force: true do |t|
    t.integer "term_loan_id"
    t.integer "state_id"
  end

  add_index "states_term_loans", ["term_loan_id", "state_id"], name: "index_states_term_loans_on_term_loan_id_and_state_id", using: :btree

  create_table "term_loans", force: true do |t|
    t.integer  "sniff_id"
    t.integer  "partner_id"
    t.string   "name",                                      default: ""
    t.boolean  "active"
    t.string   "lender_type"
    t.string   "image_file"
    t.decimal  "ranking",           precision: 3, scale: 1
    t.string   "first_comment"
    t.string   "second_comment"
    t.string   "third_comment"
    t.string   "review_url"
    t.string   "since"
    t.string   "governing_law",                             default: ""
    t.boolean  "BBB_accredit"
    t.string   "BBB_score"
    t.integer  "BBB_complaints"
    t.integer  "BBB_unresponded"
    t.string   "max_loan",                                  default: ""
    t.boolean  "spanish"
    t.boolean  "state_lic"
    t.boolean  "privacy_policy"
    t.boolean  "https"
    t.boolean  "phone_contact"
    t.boolean  "live_chat"
    t.boolean  "time_at_residence"
    t.boolean  "rent_or_own"
    t.boolean  "rent_mort_amt"
    t.boolean  "time_w_employer"
    t.boolean  "reference"
    t.decimal  "loan_amt",          precision: 6, scale: 2
    t.decimal  "payments",          precision: 4, scale: 1
    t.decimal  "pmt_freq_in_days",  precision: 5, scale: 1
    t.decimal  "pmt_amt",           precision: 7, scale: 2
    t.decimal  "cost",              precision: 7, scale: 2
    t.decimal  "apr",               precision: 3, scale: 2
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.text     "full_desc"
    t.string   "image_file_big"
    t.string   "bbb_link"
    t.string   "link1_desc"
    t.string   "link1"
    t.string   "link2_desc"
    t.string   "link2"
  end

  create_table "term_states", force: true do |t|
    t.string   "state_abbr", limit: 2
    t.string   "state",      limit: 15
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
