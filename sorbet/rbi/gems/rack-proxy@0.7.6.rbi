# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rack-proxy` gem.
# Please instead update this file by running `bin/tapioca gem rack-proxy`.

# source://rack-proxy//lib/net_http_hacked.rb#19
class Net::HTTP < ::Net::Protocol
  # Original #request with block semantics.
  #
  # def request(req, body = nil, &block)
  #   unless started?
  #     start {
  #       req['connection'] ||= 'close'
  #       return request(req, body, &block)
  #     }
  #   end
  #   if proxy_user()
  #     unless use_ssl?
  #       req.proxy_basic_auth proxy_user(), proxy_pass()
  #     end
  #   end
  #
  #   req.set_body_internal body
  #   begin_transport req
  #     req.exec @socket, @curr_http_version, edit_path(req.path)
  #     begin
  #       res = HTTPResponse.read_new(@socket)
  #     end while res.kind_of?(HTTPContinue)
  #     res.reading_body(@socket, req.response_body_permitted?) {
  #       yield res if block_given?
  #     }
  #   end_transport req, res
  #
  #   res
  # end
  #
  # source://rack-proxy//lib/net_http_hacked.rb#49
  def begin_request_hacked(req); end

  # source://rack-proxy//lib/net_http_hacked.rb#60
  def end_request_hacked; end
end

# source://rack-proxy//lib/net_http_hacked.rb#67
class Net::HTTPResponse
  # Original #reading_body with block semantics
  #
  #   @socket = sock
  #   @body_exist = reqmethodallowbody && self.class.body_permitted?
  #   begin
  #     yield
  #     self.body   # ensure to read body
  #   ensure
  #     @socket = nil
  #   end
  # end
  #
  # source://rack-proxy//lib/net_http_hacked.rb#81
  def begin_reading_body_hacked(sock, reqmethodallowbody); end

  # source://rack-proxy//lib/net_http_hacked.rb#86
  def end_reading_body_hacked; end
end

# source://rack-proxy//lib/rack/http_streaming_response.rb#4
module Rack
  class << self
    # source://rack/2.2.6.4/lib/rack/version.rb#26
    def release; end

    # source://rack/2.2.6.4/lib/rack/version.rb#19
    def version; end
  end
end

# Wraps the hacked net/http in a Rack way.
#
# source://rack-proxy//lib/rack/http_streaming_response.rb#6
class Rack::HttpStreamingResponse
  # @return [HttpStreamingResponse] a new instance of HttpStreamingResponse
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#15
  def initialize(request, host, port = T.unsafe(nil)); end

  # source://rack-proxy//lib/rack/http_streaming_response.rb#19
  def body; end

  # Returns the value of attribute cert.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def cert; end

  # Sets the attribute cert
  #
  # @param value the value to set the attribute cert to.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def cert=(_arg0); end

  # source://rack-proxy//lib/rack/http_streaming_response.rb#23
  def code; end

  # Can be called only once!
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#36
  def each(&block); end

  # source://rack-proxy//lib/rack/http_streaming_response.rb#31
  def headers; end

  # Returns the value of attribute key.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def key; end

  # Sets the attribute key
  #
  # @param value the value to set the attribute key to.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def key=(_arg0); end

  # Returns the value of attribute read_timeout.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def read_timeout; end

  # Sets the attribute read_timeout
  #
  # @param value the value to set the attribute read_timeout to.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def read_timeout=(_arg0); end

  # Returns the value of attribute ssl_version.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def ssl_version; end

  # Sets the attribute ssl_version
  #
  # @param value the value to set the attribute ssl_version to.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def ssl_version=(_arg0); end

  # #status is deprecated
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#23
  def status; end

  # source://rack-proxy//lib/rack/http_streaming_response.rb#44
  def to_s; end

  # Returns the value of attribute use_ssl.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def use_ssl; end

  # Sets the attribute use_ssl
  #
  # @param value the value to set the attribute use_ssl to.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def use_ssl=(_arg0); end

  # Returns the value of attribute verify_mode.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def verify_mode; end

  # Sets the attribute verify_mode
  #
  # @param value the value to set the attribute verify_mode to.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#13
  def verify_mode=(_arg0); end

  protected

  # Net::HTTPResponse
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#51
  def response; end

  # Net::HTTP
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#56
  def session; end

  private

  # source://rack-proxy//lib/rack/http_streaming_response.rb#74
  def close_connection; end

  # Returns the value of attribute connection_closed.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#72
  def connection_closed; end

  # Sets the attribute connection_closed
  #
  # @param value the value to set the attribute connection_closed to.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#72
  def connection_closed=(_arg0); end

  # Returns the value of attribute host.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#70
  def host; end

  # Returns the value of attribute port.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#70
  def port; end

  # Returns the value of attribute request.
  #
  # source://rack-proxy//lib/rack/http_streaming_response.rb#70
  def request; end
end

# source://rack-proxy//lib/rack/http_streaming_response.rb#7
Rack::HttpStreamingResponse::STATUSES_WITH_NO_ENTITY_BODY = T.let(T.unsafe(nil), Hash)

# Subclass and bring your own #rewrite_request and #rewrite_response
#
# source://rack-proxy//lib/rack/proxy.rb#7
class Rack::Proxy
  # @option opts
  # @param opts [Hash] a customizable set of options
  # @return [Proxy] a new instance of Proxy
  #
  # source://rack-proxy//lib/rack/proxy.rb#63
  def initialize(app = T.unsafe(nil), opts = T.unsafe(nil)); end

  # source://rack-proxy//lib/rack/proxy.rb#86
  def call(env); end

  # Return modified env
  #
  # source://rack-proxy//lib/rack/proxy.rb#91
  def rewrite_env(env); end

  # Return a rack triplet [status, headers, body]
  #
  # source://rack-proxy//lib/rack/proxy.rb#96
  def rewrite_response(triplet); end

  protected

  # source://rack-proxy//lib/rack/proxy.rb#102
  def perform_request(env); end

  class << self
    # source://rack-proxy//lib/rack/proxy.rb#41
    def build_header_hash(pairs); end

    # source://rack-proxy//lib/rack/proxy.rb#22
    def extract_http_request_headers(env); end

    # source://rack-proxy//lib/rack/proxy.rb#34
    def normalize_headers(headers); end

    protected

    # source://rack-proxy//lib/rack/proxy.rb#53
    def reconstruct_header_name(name); end

    # source://rack-proxy//lib/rack/proxy.rb#57
    def titleize(str); end
  end
end

# source://rack-proxy//lib/rack/proxy.rb#10
Rack::Proxy::HOP_BY_HOP_HEADERS = T.let(T.unsafe(nil), Hash)

# source://rack-proxy//lib/rack/proxy.rb#8
Rack::Proxy::VERSION = T.let(T.unsafe(nil), String)
