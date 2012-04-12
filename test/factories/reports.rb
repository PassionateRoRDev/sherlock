FactoryGirl.define do
  factory :report do 
    association :case
    title { String.random(10) }    
  end
end

