require 'bundler'
Bundler.require( :default )

require 'SecureRandom'
require 'yaml'
require 'pp'

use Rack::Session::Cookie,
  :key => 'pyramid_sess',
  :secret => 'store-elsewhere-later-345345435',
  :expire_after => 86400

use Rack::Flash

# Define app_root
ENV[ 'APP_ROOT' ] = File.expand_path File.dirname( __FILE__ )

# Require app
require "#{ ENV[ 'APP_ROOT' ] }/pyramid.rb"

# Require libs
Dir[ "#{ ENV[ 'APP_ROOT' ] }/lib/*.rb" ].each { |f| require f }

# Require filestore
Dir[ "#{ ENV[ 'APP_ROOT' ] }/lib/filestore/*.rb" ].each { |f| require f }

map '/' do
  run Pyramid
end
