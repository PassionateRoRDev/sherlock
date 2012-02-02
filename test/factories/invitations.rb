FactoryGirl.define do
  factory :invitation do
    case_id { Factory.create(:case).id }
    email   'jw@mustmodify.com'
    name    'Johnathon Wright'
    message 'Please come look at this cool new report.'
  end
end
