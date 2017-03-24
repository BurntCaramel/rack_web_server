require 'rack'
require 'rack/server'

class App
  def initialize
    @paths_to_content = {
      '/' => 'Welcome to the home page',
      '/about' => 'About me',
      '/contact' => 'You can contact me by the methods below'
    }
  end

  def content_for_path(path)
    @paths_to_content.fetch(path, not_found_content)
  end

  def not_found_content
    return 'Not Found'
  end

  def call(env)
    method = env['REQUEST_METHOD']
    path = env['REQUEST_PATH']
    content = content_for_path(path)
    [200, {}, [content]]
  end
end

Rack::Server.start app: App.new