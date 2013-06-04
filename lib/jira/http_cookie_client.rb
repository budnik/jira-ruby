require 'json'
require 'net/https'

module JIRA
  class HttpCookieClient < HttpClient
    def make_request(http_method, path, body='', headers={})
      @options[:session_cookie] ||= get_session_cookie
      request = Net::HTTP.const_get(http_method.to_s.capitalize).new(path, headers)
      request.body = body unless body.nil?
      request['Cookie'] = @options[:session_cookie]
      response = basic_auth_http_conn.request(request)
      response
    end

    private
      def get_session_cookie
        req = Net::HTTP::Post.new '/rest/auth/1/session'
        req.body = {username: @options[:username],
                    password: @options[:password]}.to_json
        req["Accept"] = 'application/json'
        req["Content-Type"] = 'application/json'
        basic_auth_http_conn.request(req)['set-cookie'][/JSESSIONID=\w+;/]
      end
  end
end
