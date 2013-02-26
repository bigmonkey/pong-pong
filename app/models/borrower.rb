class Borrower < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :address, :city, :zip, :address_length_months, :ssn, :birth_date, :own_home, :home_phone, :drivers_license_number, :drivers_license_state, :email, :best_time_to_call, :bank_aba, :bank_account_length_months, :bank_account_number, :bank_name, :bank_phone, :direct_deposit, :employer, :job_title, :monthly_income, :income_type, :work_phone, :pay_date1, :pay_date2, :pay_frequency, :employed_months, :active_military, :bank_account_type, :state, :requested_amount
end
