source 'https://rubygems.org'
 ruby "1.9.3"		
 gem 'rails', '3.2.11'

 
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

 gem 'pg', '0.15.1'

group :test do
	gem 'selenium-webdriver'
	gem 'capybara', '2.1.0'
  gem 'launchy'
  gem 'faker'
  gem 'guard-rspec'
end

group :development, :test do
  gem 'factory_girl_rails', '4.1.0' 
	gem 'rspec-rails', '2.13.1'
  gem 'spork-rails', '4.0.0' 	
  gem "pry", "~> 0.9.12.2"  
  gem "pry-nav", "0.2.3"  
end


# use unicorn for production and ubuntu
 gem 'unicorn', '4.6.2'

# use thin for windows
#gem 'thin', '1.5.1'
 gem 'execjs', '1.4.0'
 gem 'therubyracer', :platform => 'ruby'
 #gem 'therubyracer', '~> 0.10.2' #update to 0.11 crashes install

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~>3.2.2'
  gem 'coffee-rails', '~>3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '1.0.3'
end

gem 'jquery-rails', '2.2.1'
gem 'nokogiri', '1.5.10'

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
