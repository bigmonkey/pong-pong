source 'https://rubygems.org'

 gem 'rails', '3.2.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# converting between windows and ubuntu/mac/thin (heroku) set up 1) choose DATABASE 2) choose WEBSERVER 
# 1)DATABASE: Heroku uses postgresql so must use 'gem pg'. CW Windows and Alison Mac set up for PostgreSQL
 gem 'pg'

# uncomment for windows if using mysql database and also need to chnage database.yml file
# gem 'mysql2'

# 2)WEBSERVER: Heroku/unbuntu/Mac uses thin so need gem execjs, therubyracer, thin 
# uncomment for ubuntu/thin and comment out for Windows

 gem 'thin'
 gem 'execjs'
 gem 'therubyracer', '~> 0.10.2' #update to 0.11 crashes install


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# to get heroku db:push to work need taps
# gem 'sqlite3'
# gem 'taps'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
