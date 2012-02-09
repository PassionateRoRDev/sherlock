FactoryGirl.define do
  factory :block do
    association :case
  end

  factory :picture do
    association :block
    title 'Something'
    path '/tmp/dummy.txt'
  end

  factory :html_detail do
    association :block
    contents "Oh for a muse of fire that would ascend the brightest heaven of invention."
  end

  factory :video do
    association :block
    path '/tmp/dummy.avi'
  end
end
