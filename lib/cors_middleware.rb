class CorsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    default_headers = {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => 'GET, POST, DELETE, PUT, PATCH, OPTIONS',
      'Access-Control-Allow-Headers' => 'Content-Type, api_key, Authorization, origin'
    }
    if env["REQUEST_METHOD"] == "OPTIONS"
      puts "CorsMiddleware: Intercepted OPTIONS request: #{env["REQUEST_URI"]}"
      return [200, default_headers, ["<html><body><h1>Intercepted</h1><p>This <b>#{env["REQUEST_METHOD"]}</b> request was intercepted by the CorsMiddleware</p></body></html>"]]
    end
    status, headers, body = @app.call(env)
    [status, headers.merge(default_headers), body]
  end
end
