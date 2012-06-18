FactoryGirl.define do
  factory :storage do
    mount_point '/mnt/vol1'
    size        0
  end
end