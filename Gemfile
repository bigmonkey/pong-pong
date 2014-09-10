source 'https://rubygems.org'
 ruby "2.0.0"		
 gem 'rails', '4.0.2'

 
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

 gem 'pg', '0.17.0'

group :test do
	gem 'selenium-webdriver', "2.40.0"
	gem 'capybara', '2.1.0'
  gem 'launchy', '2.4.2'
  gem 'faker', '1.1.2'
  gem "database_cleaner", "1.2.0"
  gem 'factory_girl_rails', '4.4.0' 
  gem 'shoulda'
  gem "chromedriver-helper", "0.0.6" #download chrome driver for selenium (test browsers calls in chrome instead of firefox)
  #gem 'guard-rspec', '2.5.0'
end

group :development, :test do

	gem 'rspec-rails', '2.14.1'
  #gem 'spork-rails', '4.0.0' 	
  gem "pry", "0.9.12.6"  
  gem "pry-nav", "0.2.3"  
end



# use unicorn for production and ubuntu
gem 'unicorn', '4.8.2'

# use thin for windows
#gem 'thin', '1.5.1'
gem 'execjs', '2.0.2'
gem 'therubyracer', :platform => 'ruby'
 #gem 'therubyracer', '~> 0.10.2' #update to 0.11 crashes install

gem 'devise','3.2.3'
gem 'activeadmin', github: 'gregbell/active_admin'

gem 'sass-rails',   '4.0.1'
gem 'sass','3.2.13'
gem 'sprockets', '2.11.0'
gem 'coffee-rails', '4.0.1'

gem 'uglifier', '2.1.1'

gem 'jquery-rails', '2.3.0'
gem 'nokogiri', '1.6.0'

gem 'figaro', '0.7.0'  # used to conceal pw's and things. use rake figaro:heroku to push pw to heroku

gem 'rails_12factor', '0.0.2', group: :production

# used to upload images
gem 'paperclip', '4.1.1'

# Used by paperclip to store onto AWS S3
gem "aws-sdk", "1.38.0"

# to get heroku db:push to work need taps
# gem 'sqlite3'
# gem 'taps'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
