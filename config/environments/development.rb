Pdh::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

   # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Expands the lines which load the assets
  config.assets.debug = true

  # added for devise cw 1/13/2014
  config.action_mailer.default_url_options = { :host => 'localhost:8080' }

  # added by cw 4/17/2014 needed because nginx reverse proxy sets based on http_host
  # this gets changed to herokuapp in production but for developement/testing needs to be local
  BASE_DOMAIN = ""

  # added by cw 7/8/2014 to toggle adsense during development. Ads seem to crash Firebug.
  AD_SENSE = false
end
