FactoryGirl.define do
  
  factory :subscription_plan do
    chargify_handle 'independent'
    cases_max 2
    extra_case_price 5
    clients_max 10
    price 9
  end
  
  factory :subscription do
    status 'trialing'
    chargify_id '1723048'
    product_handle 'independent'
    cases_max 2
    cases_count 0
    extra_case_price 5
    extra_cases_count 0
    clients_max 10
    clients_count 0
    period_ends_at '2012-05-01 01:00:00'
    association :user
    association :subscription_plan
  end
    
end