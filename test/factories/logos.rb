FactoryGirl.define do
  factory :logo do  
    
    path 'logo.png'
    content_type 'image/png'
    
    association :letterhead
    association :user
  end
end