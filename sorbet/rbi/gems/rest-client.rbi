# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rest-client/all/rest-client.rbi
#
# rest-client-2.1.0
module RestClient
  def self.add_before_execution_proc(&proc); end
  def self.before_execution_procs; end
  def self.create_log(param); end
  def self.delete(url, headers = nil, &block); end
  def self.get(url, headers = nil, &block); end
  def self.head(url, headers = nil, &block); end
  def self.log; end
  def self.log=(log); end
  def self.options(url, headers = nil, &block); end
  def self.patch(url, payload, headers = nil, &block); end
  def self.post(url, payload, headers = nil, &block); end
  def self.proxy; end
  def self.proxy=(value); end
  def self.proxy_set?; end
  def self.put(url, payload, headers = nil, &block); end
  def self.reset_before_execution_procs; end
  def self.version; end
end
module RestClient::Platform
  def self.architecture; end
  def self.default_user_agent; end
  def self.jruby?; end
  def self.mac_mri?; end
  def self.ruby_agent_version; end
  def self.windows?; end
end
class RestClient::Exception < RuntimeError
  def default_message; end
  def http_body; end
  def http_code; end
  def http_headers; end
  def initialize(response = nil, initial_response_code = nil); end
  def message; end
  def message=(arg0); end
  def original_exception; end
  def original_exception=(arg0); end
  def response; end
  def response=(arg0); end
  def to_s; end
end
class RestClient::ExceptionWithResponse < RestClient::Exception
end
class RestClient::RequestFailed < RestClient::ExceptionWithResponse
  def default_message; end
  def to_s; end
end
module RestClient::Exceptions
end
class RestClient::Continue < RestClient::RequestFailed
  def default_message; end
end
class RestClient::SwitchingProtocols < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Processing < RestClient::RequestFailed
  def default_message; end
end
class RestClient::OK < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Created < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Accepted < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NonAuthoritativeInformation < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NoContent < RestClient::RequestFailed
  def default_message; end
end
class RestClient::ResetContent < RestClient::RequestFailed
  def default_message; end
end
class RestClient::PartialContent < RestClient::RequestFailed
  def default_message; end
end
class RestClient::MultiStatus < RestClient::RequestFailed
  def default_message; end
end
class RestClient::AlreadyReported < RestClient::RequestFailed
  def default_message; end
end
class RestClient::IMUsed < RestClient::RequestFailed
  def default_message; end
end
class RestClient::MultipleChoices < RestClient::RequestFailed
  def default_message; end
end
class RestClient::MovedPermanently < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Found < RestClient::RequestFailed
  def default_message; end
end
class RestClient::SeeOther < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NotModified < RestClient::RequestFailed
  def default_message; end
end
class RestClient::UseProxy < RestClient::RequestFailed
  def default_message; end
end
class RestClient::SwitchProxy < RestClient::RequestFailed
  def default_message; end
end
class RestClient::TemporaryRedirect < RestClient::RequestFailed
  def default_message; end
end
class RestClient::PermanentRedirect < RestClient::RequestFailed
  def default_message; end
end
class RestClient::BadRequest < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Unauthorized < RestClient::RequestFailed
  def default_message; end
end
class RestClient::PaymentRequired < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Forbidden < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NotFound < RestClient::RequestFailed
  def default_message; end
end
class RestClient::MethodNotAllowed < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NotAcceptable < RestClient::RequestFailed
  def default_message; end
end
class RestClient::ProxyAuthenticationRequired < RestClient::RequestFailed
  def default_message; end
end
class RestClient::RequestTimeout < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Conflict < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Gone < RestClient::RequestFailed
  def default_message; end
end
class RestClient::LengthRequired < RestClient::RequestFailed
  def default_message; end
end
class RestClient::PreconditionFailed < RestClient::RequestFailed
  def default_message; end
end
class RestClient::PayloadTooLarge < RestClient::RequestFailed
  def default_message; end
end
class RestClient::URITooLong < RestClient::RequestFailed
  def default_message; end
end
class RestClient::UnsupportedMediaType < RestClient::RequestFailed
  def default_message; end
end
class RestClient::RangeNotSatisfiable < RestClient::RequestFailed
  def default_message; end
end
class RestClient::ExpectationFailed < RestClient::RequestFailed
  def default_message; end
end
class RestClient::ImATeapot < RestClient::RequestFailed
  def default_message; end
end
class RestClient::TooManyConnectionsFromThisIP < RestClient::RequestFailed
  def default_message; end
end
class RestClient::UnprocessableEntity < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Locked < RestClient::RequestFailed
  def default_message; end
end
class RestClient::FailedDependency < RestClient::RequestFailed
  def default_message; end
end
class RestClient::UnorderedCollection < RestClient::RequestFailed
  def default_message; end
end
class RestClient::UpgradeRequired < RestClient::RequestFailed
  def default_message; end
end
class RestClient::PreconditionRequired < RestClient::RequestFailed
  def default_message; end
end
class RestClient::TooManyRequests < RestClient::RequestFailed
  def default_message; end
end
class RestClient::RequestHeaderFieldsTooLarge < RestClient::RequestFailed
  def default_message; end
end
class RestClient::RetryWith < RestClient::RequestFailed
  def default_message; end
end
class RestClient::BlockedByWindowsParentalControls < RestClient::RequestFailed
  def default_message; end
end
class RestClient::InternalServerError < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NotImplemented < RestClient::RequestFailed
  def default_message; end
end
class RestClient::BadGateway < RestClient::RequestFailed
  def default_message; end
end
class RestClient::ServiceUnavailable < RestClient::RequestFailed
  def default_message; end
end
class RestClient::GatewayTimeout < RestClient::RequestFailed
  def default_message; end
end
class RestClient::HTTPVersionNotSupported < RestClient::RequestFailed
  def default_message; end
end
class RestClient::VariantAlsoNegotiates < RestClient::RequestFailed
  def default_message; end
end
class RestClient::InsufficientStorage < RestClient::RequestFailed
  def default_message; end
end
class RestClient::LoopDetected < RestClient::RequestFailed
  def default_message; end
end
class RestClient::BandwidthLimitExceeded < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NotExtended < RestClient::RequestFailed
  def default_message; end
end
class RestClient::NetworkAuthenticationRequired < RestClient::RequestFailed
  def default_message; end
end
class RestClient::Exceptions::Timeout < RestClient::RequestTimeout
  def initialize(message = nil, original_exception = nil); end
end
class RestClient::Exceptions::OpenTimeout < RestClient::Exceptions::Timeout
  def default_message; end
end
class RestClient::Exceptions::ReadTimeout < RestClient::Exceptions::Timeout
  def default_message; end
end
class RestClient::ServerBrokeConnection < RestClient::Exception
  def initialize(message = nil); end
end
class RestClient::SSLCertificateNotVerified < RestClient::Exception
  def initialize(message = nil); end
end
module RestClient::Utils
  def self._cgi_parseparam(s); end
  def self.cgi_parse_header(line); end
  def self.deprecated_cgi_parse_header(line); end
  def self.encode_query_string(object); end
  def self.escape(string); end
  def self.flatten_params(object, uri_escape = nil, parent_key = nil); end
  def self.get_encoding_from_headers(headers); end
end
class RestClient::Request
  def args; end
  def cookie_jar; end
  def cookies; end
  def default_headers; end
  def execute(&block); end
  def fetch_body_to_tempfile(http_response); end
  def headers; end
  def initialize(args); end
  def inspect; end
  def log; end
  def log_request; end
  def make_cookie_header; end
  def make_headers(user_headers); end
  def max_redirects; end
  def maybe_convert_extension(ext); end
  def method; end
  def net_http_do_request(http, req, body = nil, &block); end
  def net_http_object(hostname, port); end
  def net_http_request_class(method); end
  def normalize_method(method); end
  def normalize_url(url); end
  def open_timeout; end
  def parse_url_with_auth!(url); end
  def parser; end
  def password; end
  def payload; end
  def print_verify_callback_warnings; end
  def process_cookie_args!(uri, headers, args); end
  def process_result(res, start_time, tempfile = nil, &block); end
  def process_url_params(url, headers); end
  def processed_headers; end
  def proxy; end
  def proxy_uri; end
  def raw_response; end
  def read_timeout; end
  def redacted_uri; end
  def redacted_url; end
  def redirection_history; end
  def redirection_history=(arg0); end
  def self.default_ssl_cert_store; end
  def self.execute(args, &block); end
  def setup_credentials(req); end
  def ssl_ca_file; end
  def ssl_ca_path; end
  def ssl_cert_store; end
  def ssl_ciphers; end
  def ssl_client_cert; end
  def ssl_client_key; end
  def ssl_opts; end
  def ssl_verify_callback; end
  def ssl_verify_callback_warnings; end
  def ssl_version; end
  def stringify_headers(headers); end
  def transmit(uri, req, payload, &block); end
  def uri; end
  def url; end
  def use_ssl?; end
  def user; end
  def verify_ssl; end
end
module RestClient::AbstractResponse
  def _follow_redirection(new_args, &block); end
  def check_max_redirects; end
  def code; end
  def cookie_jar; end
  def cookies; end
  def description; end
  def duration; end
  def end_time; end
  def exception_with_response; end
  def follow_get_redirection(&block); end
  def follow_redirection(&block); end
  def headers; end
  def history; end
  def inspect; end
  def log; end
  def log_response; end
  def net_http_res; end
  def raw_headers; end
  def request; end
  def response_set_vars(net_http_res, request, start_time); end
  def return!(&block); end
  def self.beautify_headers(headers); end
  def start_time; end
  def to_i; end
end
class RestClient::Response < String
  def body; end
  def body_truncated(length); end
  def inspect; end
  def self.create(body, net_http_res, request, start_time = nil); end
  def self.fix_encoding(response); end
  def to_s; end
  def to_str; end
  include RestClient::AbstractResponse
end
class RestClient::RawResponse
  def body; end
  def end_time; end
  def file; end
  def initialize(tempfile, net_http_res, request, start_time = nil); end
  def inspect; end
  def request; end
  def size; end
  def start_time; end
  def to_s; end
  include RestClient::AbstractResponse
end
class RestClient::Resource
  def [](suburl, &new_block); end
  def block; end
  def concat_urls(url, suburl); end
  def delete(additional_headers = nil, &block); end
  def get(additional_headers = nil, &block); end
  def head(additional_headers = nil, &block); end
  def headers; end
  def initialize(url, options = nil, backwards_compatibility = nil, &block); end
  def log; end
  def open_timeout; end
  def options; end
  def password; end
  def patch(payload, additional_headers = nil, &block); end
  def post(payload, additional_headers = nil, &block); end
  def put(payload, additional_headers = nil, &block); end
  def read_timeout; end
  def to_s; end
  def url; end
  def user; end
end
class RestClient::ParamsArray
  def each(*args, &blk); end
  def empty?; end
  def initialize(array); end
  def process_input(array); end
  def process_pair(pair); end
  include Enumerable
end
module RestClient::Payload
  def _has_file?(obj); end
  def generate(params); end
  def has_file?(params); end
  extend RestClient::Payload
end
class RestClient::Payload::Base
  def build_stream(params); end
  def close; end
  def closed?; end
  def headers; end
  def initialize(params); end
  def length; end
  def read(*args); end
  def short_inspect; end
  def size; end
  def to_s; end
  def to_s_inspect; end
end
class RestClient::Payload::Streamed < RestClient::Payload::Base
  def build_stream(params = nil); end
  def length; end
  def size; end
end
class RestClient::Payload::UrlEncoded < RestClient::Payload::Base
  def build_stream(params = nil); end
  def headers; end
end
class RestClient::Payload::Multipart < RestClient::Payload::Base
  def boundary; end
  def build_stream(params); end
  def close; end
  def create_file_field(s, k, v); end
  def create_regular_field(s, k, v); end
  def handle_key(key); end
  def headers; end
  def mime_for(path); end
end
module RestClient::Windows
end
