FactoryGirl.define do
  factory :picture do
    association :block
    path '/tmp/dummy.txt'
  end
end

