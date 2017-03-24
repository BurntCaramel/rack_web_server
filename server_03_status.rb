require 'rack'
require 'rack/server'

class App
  def initialize
    @paths_to_content = {
      '/' => {
        statusCode: 200,
        html: 'Welcome to the home page'
      },
      '/about' => {
        statusCode: 200,
        html: 'About me'
      },
      '/contact' => {
        statusCode: 200,
        html: 'You can contact me by the methods below'
      }
    }
  end

  def content_for_path(path)
    @paths_to_content.fetch(path, not_found_content)
  end

  def not_found_content
    return {
      statusCode: 404,
      html: 'Not Found'
    }
  end

  def call(env)
    method = env['REQUEST_METHOD']
    path = env['REQUEST_PATH']
    content = content_for_path(path)
    statusCode = content[:statusCode]
    html = content[:html]
    [statusCode, {}, [html]]
  end
end

Rack::Server.start app: App.new