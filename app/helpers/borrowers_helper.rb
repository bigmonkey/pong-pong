module BorrowersHelper

def time_length
[
	['...', ''],
	['5+ Years', '58'],
	['4+ Years', '48'],
	['3+ Years', '36'],
	['2+ Years', '24'],
	['1+ Year', '12'],
	['9+ Months', '12'],
	['8+ Months', '9'],
	['6 Months', '6'],
	['5 Months', '5'],
	['4 Months', '4'],
	['3 Months', '3'],
	['2 Months', '2'],
	['1 Months', '1']
]
end

def pay_freq
[
	['...', ''],	
	['Every Week', 'WEEKLY'],
	['Every Two Weeks', 'BIWEEKLY'],
	['Twice a Month', 'TWICEMONTHLY'],
	['Monthly', 'MONTHLY']
]
end

def call_times
[
	['...', ''],
	['Anytime', 'ANYTIME'],	
	['Mornings', 'MORNING'],
	['Afternoons', 'AFTERNOON'],
	['Evenings', 'EVENING ']
]
end

end
