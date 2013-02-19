# This patch modifies the InfusionSoft connection function to have proper SSL connection under Linux/MacOSX
require "xmlrpc/client"

module Infusionsoft
  module Connection
  
    UBUNTU_CA_PATH = '/etc/ssl/certs'
    MAC_OSX_CA_FILE = '/opt/local/share/curl/curl-ca-bundle.crt'

    def connection(service_call, *args)
      # Rails.logger.info "InfusionSoft service_call: #{service_call}, args: #{args}"
      server = XMLRPC::Client.new3({
        'host' => api_url,
        'path' => "/api/xmlrpc",
        'port' => 443,
        'use_ssl' => true
      })
      
      # Set the certs path
      server.ca_path = UBUNTU_CA_PATH if File.exists?(UBUNTU_CA_PATH)
      server.ca_file = MAC_OSX_CA_FILE if File.exists?(MAC_OSX_CA_FILE)
        
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
