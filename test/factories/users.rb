FactoryGirl.define do
  factory :user do
    email { "user@#{String.random(5)}.com" }
    password 'password'
  end
end

