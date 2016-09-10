# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

require 'rack/contrib/static_cache'
use Rack::StaticCache, :urls => ['/images', '/stylesheets', '/javascripts', '/fonts'],
                       :root => "build"


run Rails.application
