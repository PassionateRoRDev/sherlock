FactoryGirl.define do
  factory :contact_message do
    first_name 'John'
    last_name 'Smith'
    email 'john.smith@guest.com'
    message 'Hello from a customer'
  end  
end