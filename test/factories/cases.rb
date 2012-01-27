FactoryGirl.define do
  factory :case do 
    title { "Case ##{200+rand(300)}" }
    summary "Mrs. Fox wants Mr. Fox to stop ... being so clever."
    association :user
  end
end

