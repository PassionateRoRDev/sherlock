# This patch modifies the InfusionSoft connection function to have proper SSL connection under Linux/MacOSX
require "xmlrpc/client"

module Infusionsoft
  module Connection
  
    def connection(service_call, *args)
      # Rails.logger.info "InfusionSoft service_call: #{service_call}, args: #{args}"
      server = XMLRPC::Client.new3({
        'host' => api_url,
        'path' => "/api/xmlrpc",
        'port' => 443,
        'use_ssl' => true
      })
      
      # Set the the CA file for SSL
      http_obj = server.instance_variable_get("@http")
      http_obj.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http_obj.ca_file = Rails.root.join('lib/ca-bundle.crt').to_s

      begin
        result = server.call("#{service_call}", api_key, *args)
        if result.nil?; result = [] end
      rescue Timeout::Error
        retry if ok_to_retry
      rescue
        retry if ok_to_retry
      end

      return result
    end
  end
end