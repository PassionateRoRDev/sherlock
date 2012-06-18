FactoryGirl.define do
  factory :block do
    association :case
  end
  
  factory :html_detail do
    association :block
    contents "Oh for a muse of fire that would ascend the brightest heaven of invention."
  end
  
  factory :data_log_detail do
    association :block
    day '05/03/2012'
    hour '02:30pm'
    location 'New York City'
    contents 'Sample contents for the data log block'
  end

  factory :picture do
    association :block    
    title 'Something'
    path '/tmp/dummy.png'
    unique_code Picture.generate_unique_code
  end
  
  factory :video do
    association :block
    path '/tmp/dummy.avi'
  end
end
