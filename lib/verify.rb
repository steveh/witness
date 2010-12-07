require "active_support/core_ext/class/inheritable_attributes"
require "uri"
require "rack/utils"
require "signify"

require "verify/base"
require "verify/error"

module Verify

  def self.update_url(url, new_params)
    uri = URI.parse(url)
    query = uri.query
    params = Rack::Utils.parse_nested_query(query).symbolize_keys
    uri.path = "/" if uri.path == ""
    uri.scheme = "http" if uri.scheme.nil?
    uri.query = params.update(new_params).to_query
    uri.to_s
  rescue
    nil
  end

end