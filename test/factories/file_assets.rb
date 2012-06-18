FactoryGirl.define do
  factory :file_asset do
    path '123456789.bin'
    filesize 2048
    content_type 'application/binary'
    role :main
    association :user
  end  
end