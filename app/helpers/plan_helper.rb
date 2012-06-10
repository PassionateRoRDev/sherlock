module PlanHelper
  
  def chargify_url(plan, user = nil)                
    Sherlock::Chargify.new.base_url + plan.chargify_slug + '/subscriptions/new' + url_params(user)
  end
  
  private
  
  def url_params(user)
    if user
      "?email=#{URI.escape(user.email.to_s)}" +
      "&first_name=#{URI.escape(user.first_name.to_s)}" +
      "&last_name=#{URI.escape(user.last_name.to_s)}" +
      "&billing_zip=#{user.billing_zip.to_s}" +
      "&billing_city=#{URI.escape(user.billing_city.to_s)}" +
      "&phone=#{URI.escape(user.phone.to_s)}" +
      "&organization=#{URI.escape(user.company_name.to_s)}"
    else
      ''
    end
  end
  
end