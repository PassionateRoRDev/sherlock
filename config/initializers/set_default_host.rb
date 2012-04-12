#module DefaultHostHelper
#  def set_default_host
#    ActionMailer::Base.default_url_options[:host] = request.host_with_port
#  end
#
#  def self.included( parent )
#    parent.before_filter :set_default_host
#  end
#end
#Devise::PasswordsController.send(:include, DefaultHostHelper)
#
