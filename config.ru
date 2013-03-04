# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)


use Rack::ReverseProxy do
  reverse_proxy(/^\/blog(\/.*)$/,
    'http://badcreditsecuredcard.com$1',
    opts = {:preserve_host => true})
end


run Pdh::Application
