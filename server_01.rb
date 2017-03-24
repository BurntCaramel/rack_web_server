require 'rack'
require 'rack/server'

class App
  def self.call(env)
    [200, {}, ['Hello!!!']]
  end
end

Rack::Server.start app: App