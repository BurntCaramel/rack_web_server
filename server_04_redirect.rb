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
      },
      '/emailme' => {
        statusCode: 302,
        headers: {
          'Location' => '/contact'
        }
      }
    }
  end

  def content_for_path(path)
    @paths_to_content.fetch(path) do |path|
      # If we have a trailing slash
      if path[-1] === '/'
        path_without_trailing_slash = path[0..-2]
        if @paths_to_content.include?(path_without_trailing_slash)
          next redirect_content_to(path_without_trailing_slash)
        end
      end
      not_found_content
    end
  end

  def redirect_content_to(path)
    return {
      statusCode: 302,
      headers: {
        'Location' => path
      }
    }
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
    headers = content.fetch(:headers, {})
    html = content.fetch(:html, '')
    [statusCode, headers, [html]]
  end
end

Rack::Server.start app: App.new