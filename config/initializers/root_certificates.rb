# Downloaded from
# https://gist.github.com/arnebrasseur/2659619
# 
# Ruby 1.9 doesn't contain any SSL root certificates, neither does it read the ones
# installed with your operating system. This results in an error like
# 
# SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
# 
# This solution is based on http://martinottenwaelter.fr/2010/12/ruby19-and-the-ssl-error/
# but can be used to monkey patch 3rd party tools, e.g. Github's 'gist' command. 
# 
# It should work on Debian/Ubuntu Linux and Mac OS X. 

require 'net/https'
class Net::HTTP
  alias orig_initialize initialize
  def initialize(*args,&blk)
    # Rails.logger.info "SSL fix called: #{args}"
    orig_initialize(*args,&blk)
    self.ca_path = '/etc/ssl/certs' if File.exists?('/etc/ssl/certs') # Ubuntu
    self.ca_file = '/opt/local/share/curl/curl-ca-bundle.crt' if File.exists?('/opt/local/share/curl/curl-ca-bundle.crt') # Mac OS X
  end
end
