FactoryGirl.define do
  factory :video do
    association :block
    path '/tmp/dummy.avi'
  end
end

