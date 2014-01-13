source 'https://rubygems.org'
 ruby "2.0.0"		
 gem 'rails', '4.0.2'

 
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

 gem 'pg', '0.17.0'

group :test do
	gem 'selenium-webdriver', "~>2.38.0"
	gem 'capybara', '2.1.0'
  gem 'launchy', '2.4.2'
  gem 'faker', '1.1.2'
  gem 'guard-rspec', '2.5.0'
end

group :development, :test do
  gem 'factory_girl_rails', '4.2.0' 
	gem 'rspec-rails', '2.13.1'
  gem 'spork-rails', '4.0.0' 	
  gem "pry", "0.9.12.2"  
  gem "pry-nav", "0.2.3"  
end


# use unicorn for production and ubuntu
gem 'unicorn', '4.7.0'

# use thin for windows
#gem 'thin', '1.5.1'
gem 'execjs', '2.0.2'
gem 'therubyracer', :platform => 'ruby'
 #gem 'therubyracer', '~> 0.10.2' #update to 0.11 crashes install

gem 'devise','3.2.2'
gem 'activeadmin', github: 'gregbell/active_admin'

gem 'sass-rails',   '4.0.1'
gem 'coffee-rails', '4.0.1'

gem 'uglifier', '2.1.1'

gem 'jquery-rails', '2.3.0'
gem 'nokogiri', '1.6.0'

gem 'figaro', '0.7.0'  # used to conceal pw's and things. use rake figaro:heroku to push pw to heroku

gem 'rails_12factor', '0.0.2', group: :production

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
