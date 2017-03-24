require 'rack'
require 'rack/server'

class App
  def initialize
    @paths_to_content = {
      '/' => {
        status_code: 200,
        html: 'Welcome to the home page'
      },
      '/about' => {
        status_code: 200,
        html: 'About me'
      },
      '/contact' => {
        status_code: 200,
        html: 'You can contact me by the methods below'
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
      status_code: 302,
      headers: {
        'Location' => path
      }
    }
  end

  def not_found_content
    return {
      status_code: 404,
      html: 'Not Found'
    }
  end

  def call(env)
    method = env['REQUEST_METHOD']
    path = env['REQUEST_PATH']
    content = content_for_path(path)

    if path.start_with?('/public/')
      sub_path = path.sub('/public/', '')
      file_extension = File.extname(sub_path)
      local_file_path = File.join(__dir__, 'public', sub_path)
      file = File.open(local_file_path)
      return [200, { 'Content-Type' => 'image/gif' }, file]
    end

    status_code = content[:status_code]
    headers = content.fetch(:headers, {})
    html = content.fetch(:html, '')
    [status_code, headers, [html]]
  end
end

Rack::Server.start app: App.new